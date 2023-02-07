import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsy/Authentication/login.dart';
import 'package:wsy/Authentication/register.dart';
import 'package:wsy/Config/config.dart';

class choicesScreen extends StatefulWidget {
  @override
  _choicesScreen createState() => _choicesScreen();
}

class _choicesScreen extends State<choicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0XFF7fb7b6),
        image: DecorationImage(
            image: AssetImage('img/splashScreen.jpeg'), fit: BoxFit.contain),
      ),
      child: SafeArea(
        child: Container(
          color: Colors.black.withOpacity(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => Register());
                          Navigator.push(context, route);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: wsy.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (_) => Login());
                          Navigator.push(context, route);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: wsy.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
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

  Logo() {
    return Container(
      width: 130,
      height: 130,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Image(
          image: AssetImage('img/splashScreen.jpeg'),
          width: 12,
        ),
      ),
    );
  }
}
