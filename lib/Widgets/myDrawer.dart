import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wsy/global/global.dart';
import 'package:wsy/splashScreen/splashScreen.dart';

import '../Address/addAddress.dart';
import '../Config/config.dart';
import '../Orders/myOrders.dart';
import '../Store/storehome.dart';

class MyDrawer extends StatelessWidget {
  Color color1 = const Color.fromARGB(128, 208, 199, 1);
  Color color2 = const Color.fromARGB(19, 84, 122, 1);
  String image = null;
  @override
  Widget build(BuildContext context) {
    print(wsy.userAvatarUrl);
    if (wsy.userAvatarUrl.isNotEmpty) {
      image = wsy.sharedPreferences.getString(wsy.userAvatarUrl);
    }

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: const BoxDecoration(
              color: wsy.primaryColor,
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(18.0)),
                  elevation: 8.0,
                  child: SizedBox(
                      height: 160.0,
                      width: 160.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          image,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  wsy.sharedPreferences.getString(wsy.userName).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            decoration: const BoxDecoration(
              color: wsy.primaryColor,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shop,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    var auth = FirebaseAuth.instance;
                    auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => MySplashScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
