import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:wsy/Admin/showOrders.dart';
import 'package:wsy/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../splashScreen/splashScreen.dart';
import 'package:intl/intl.dart' as dateFormat;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _serviceNumber = TextEditingController();
  final TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;

  XFile imageXFile;
  final ImagePicker _picker = ImagePicker();
  String uploadImageUrl = "";
  File imageFile;

  String _myActivityCatagory;
  String _myActivityAge;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return imageXFile == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: wsy.primaryColor,
          ),
        ),
        title: const Text(
          "WSY",
          style: TextStyle(fontSize: 25, letterSpacing: 2),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.shop_two_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => ShowOrders());
            Navigator.push(context, route);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => MySplashScreen());
              Navigator.pushReplacement(context, route);
            },
            icon: const Icon(
              Icons.logout,
              size: 25,
            ),
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: const BoxDecoration(
        color: wsy.primaryColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () => takeImage(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                ),
                child: const Text(
                  "Add New Items",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: const Text(
              "Add Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: _getImageFromGallary,
                child: const Text("Select From Gallery with Gallery",
                    style: TextStyle(color: Colors.green)),
              ),
              SimpleDialogOption(
                onPressed: capturePhotoWithCamera,
                child: const Text("Take Picture with Camera",
                    style: TextStyle(color: Colors.green)),
              ),
              SimpleDialogOption(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _getImageFromGallary() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = (File(imageXFile.path));
    setState(() {
      imageFile;
    });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera);
    imageFile = (File(imageXFile.path));
    setState(() {
      imageFile;
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: wsy.primaryColor,
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo),
        title: const Text(
          "Adding New Service",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : const Text(""),
          SizedBox(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(imageFile), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _shortInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _titleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _descriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.indigo),
                controller: _priceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.home_repair_service,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: DropDownFormField(
                      titleText: 'Category',
                      hintText: 'Please choose one',
                      value: _myActivityCatagory,
                      onChanged: (value) {
                        setState(() {
                          _myActivityCatagory = value;
                        });
                      },
                      dataSource: const [
                        {
                          "display": "Body Care",
                          "value": "BodyCare",
                        },
                        {
                          "display": "Spa",
                          "value": "Spa",
                        },
                        {
                          "display": "Barber for men",
                          "value": "BarberForMen",
                        },
                        {
                          "display": "Derma",
                          "value": "Derma",
                        },
                        {
                          "display": "Physical Therapy",
                          "value": "PhysicalTherapy",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropDownFormField(
                    titleText: 'Age',
                    hintText: 'Please choose one',
                    value: _myActivityAge,
                    onChanged: (value) {
                      setState(() {
                        _myActivityAge = value;
                      });
                    },
                    dataSource: const [
                      {
                        "display": "50 Plus",
                        "value": "50Plus",
                      },
                      {
                        "display": "34 - 49",
                        "value": "34To49",
                      },
                      {
                        "display": "18 - 33",
                        "value": "18To33",
                      },
                      {
                        "display": "All",
                        "value": "All",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ElevatedButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add Service",
                style: TextStyle(fontSize: 23.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.push(context, route);
    setState(() {
      imageFile;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadingItemImage(imageXFile);
    saveItemInfo(imageDownloadUrl);
  }

  // Save a copy of the image
  Future<String> uploadingItemImage(mFileImage) async {
    String downloadUrl;
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("Items").child(imageName);
    fStorage.UploadTask uploadTask = reference.putFile(imageFile);
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      uploadImageUrl = url;
    });
    return uploadImageUrl;
  }

  saveItemInfo(String downloadUrl) async {
    String currentUser = wsy.auth.currentUser.uid;
    await FirebaseFirestore.instance.collection("Items").add({
      "serviceProviderID": currentUser,
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate":
          dateFormat.DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
      "serviceAge": _myActivityAge.toString().trim(),
      "serviceCategory": _myActivityCatagory.toString().trim(),
    });

    setState(() {
      imageFile;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _serviceNumber.clear();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });

    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.push(context, route);
  }
}
