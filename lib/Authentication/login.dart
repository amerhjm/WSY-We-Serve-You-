import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wsy/Admin/uploadItems.dart';
import 'package:wsy/Config/config.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import '../Widgets/customTextField.dart';
import '../global/global.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Material(
      color: Color(0XFF7fb7b6),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: Image.asset(
                            "img/splashScreen.jpeg",
                            height: 240.0,
                            width: 240.0,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailTextEditingController,
                                data: Icons.email,
                                hintText: "Email",
                                isObsecure: false,
                              ),
                              CustomTextField(
                                controller: _passwordTextEditingController,
                                data: Icons.lock,
                                hintText: "Password",
                                isObsecure: true,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _emailTextEditingController.text.isNotEmpty &&
                                    _passwordTextEditingController
                                        .text.isNotEmpty
                                ? loginUser()
                                : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return const ErrorAlertDialog(
                                        message:
                                            "Please write Email and Password",
                                      );
                                    });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: wsy.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  User firebaseUser;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Authenticating, Please wait...",
          );
        });
    await wsy.auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
    if (firebaseUser != null) {
      readData(firebaseUser);
    }
  }

  Future readData(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      String userType = snapshot.data()['userType'];
      switch (userType) {
        case "regularUser":
          await wsy.sharedPreferences.setString("userUID", currentUser.uid);
          await wsy.sharedPreferences
              .setString("email", currentUser.email.toString());
          if (snapshot.data()["url"] != null) {
            await wsy.sharedPreferences
                .setString("userImage", snapshot.data()["url"]);
          }
          await wsy.sharedPreferences
                  .setString("name", snapshot.data()["name"]) ??
              '';
          // Go to
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
          break;

        case "serviceProvider":
          await wsy.sharedPreferences.setString("userUID", currentUser.uid);
          await wsy.sharedPreferences
              .setString("email", currentUser.email.toString());
          if (snapshot.data()["url"] != null) {
            await wsy.sharedPreferences
                .setString("userImage", snapshot.data()["url"]);
          }
          await wsy.sharedPreferences
                  .setString("name", snapshot.data()["name"]) ??
              '';

          // Go to ServiceProvider
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
          break;
      }
    });
  }
}
