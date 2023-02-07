import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsy/Config/config.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import '../Widgets/customTextField.dart';
import '../global/global.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

BestTutorSite _site = BestTutorSite.male;

enum BestTutorSite { male, female }

class _RegisterState extends State<Register> {
// when making account
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _ageTextEditingController =
      TextEditingController();
  final TextEditingController _genderEdtiginController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();

  static const String _title = 'Radio Button Example';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // for images
  String userImageUrl = "";
  XFile imageXFile;
  File image;
  final ImagePicker _picker = ImagePicker();

// This function to pick image
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    image = (File(imageXFile.path));
    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile.path)),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameTextEditingController,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailTextEditingController,
                      data: Icons.email,
                      hintText: "Email",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _ageTextEditingController,
                      data: Icons.numbers,
                      hintText: "Phone Number",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _phoneNumberTextEditingController,
                      data: Icons.person_remove_alt_1_rounded,
                      hintText: "Age",
                      isObsecure: false,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Male'),
                            leading: Radio(
                              value: BestTutorSite.male,
                              groupValue: _site,
                              onChanged: (BestTutorSite value) {
                                setState(() {
                                  _site = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('Female'),
                            leading: Radio(
                              value: BestTutorSite.female,
                              groupValue: _site,
                              onChanged: (BestTutorSite value) {
                                setState(() {
                                  _site = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cPasswordTextEditingController,
                      data: Icons.lock,
                      hintText: "Confirm Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  uploadAndSaveImage();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(wsy.primaryColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 4.0,
                width: _screenWidth * 0.8,
                color: wsy.primaryColor,
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadAndSaveImage() async {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isNotEmpty
            ? uploadToStorage()
            : displayDialog("Please fill up the registration form..")
        : displayDialog("Password do not match.");
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Registering, Please wait....",
          );
        });

    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    if (imageXFile == null) {
    } else {
      fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child("usersImages")
          .child(imageFileName);
      fStorage.UploadTask uploadTask = reference.putFile(image);
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        userImageUrl = url;
      });
    }
    _registerUser();
  }

  String firebaseUser;

  void _registerUser() async {
    await wsy.auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((_auth) {
      firebaseUser = _auth.user.uid;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    saveUserInfoToFireStor(firebaseUser).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }

  Future saveUserInfoToFireStor(String UID) async {
    wsy.firestore.collection("users").doc(UID).set({
      "uid": UID,
      "email": _emailTextEditingController.text,
      "name": _nameTextEditingController.text.trim(),
      "phoneNumber": _ageTextEditingController.text.trim(),
      "age": int.parse(_phoneNumberTextEditingController.text.trim()),
      "gender": _site.name.toString(),
      "url": userImageUrl,
      "userType": "regularUser",
    });

    //Save Data Locally
    await wsy.sharedPreferences.setString(wsy.userUID, UID);
    await wsy.sharedPreferences
        .setString(wsy.userEmail, _emailTextEditingController.text.trim());
    await wsy.sharedPreferences.setString(wsy.userAvatarUrl, userImageUrl);
    await wsy.sharedPreferences
        .setString(wsy.userName, _nameTextEditingController.text.trim());
    await wsy.sharedPreferences.setInt(
        wsy.age, int.parse(_phoneNumberTextEditingController.text.trim()));
    await wsy.sharedPreferences
        .setString(wsy.phoneNumber, _ageTextEditingController.text.trim());
    await wsy.sharedPreferences.setString(wsy.gender, _site.name.toString());
  }
}
