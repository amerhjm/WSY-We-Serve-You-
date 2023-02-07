import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wsy/Authentication/choicesScreen.dart';
import '../Store/storehome.dart';
import '../global/global.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreen createState() => _MySplashScreen();
}

class _MySplashScreen extends State<MySplashScreen> {
// Function
  displaySplash() {
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => StoreHome()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => choicesScreen()),
        );
      }
    });
  }

  @override
  // This function is the first function start when that page open
  void initState() {
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: const Color(0xFF7fb7b6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "img/splashScreen.jpeg",
                width: 200.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Welcome To We Serve You(WSY)",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                textDirection: TextDirection.ltr,
              ),
              const Text(
                "is a mobile applicatino will be providing services for users, home based services.",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
