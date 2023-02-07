import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wsy/Config/config.dart';

import '../Models/address.dart';
import '../Store/storehome.dart';
import '../Widgets/customAppBar.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  Position position;
  List<Placemark> placeMarks;

  //getCurrentLocation
  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark pMark = placeMarks[0];
    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, '
        '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}'
        '${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
    cFlatHomeNumber.text = pMark.subThoroughfare;
    cCity.text = pMark.administrativeArea;
    cState.text = pMark.subAdministrativeArea;
    cPinCode.text = pMark.postalCode;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              //add to firestore
              wsy.firestore
                  .collection(wsy.collectionUser)
                  .doc(wsy.sharedPreferences.getString(wsy.userUID))
                  .collection(wsy.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                const snack =
                    SnackBar(content: Text("New Address added successfully."));
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: const Text("Done"),
          backgroundColor: wsy.primaryColor,
          icon: const Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Flat Number / House Number",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State / Country",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                    TextButton.icon(
                      label: const Text("Get Current Address"),
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        getCurrentLocation();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({
    Key key,
    this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty." : null,
      ),
    );
  }
}
