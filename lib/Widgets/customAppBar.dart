import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsy/Config/config.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;

  MyAppBar({Key key, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: wsy.primaryColor,
        ),
      ),
      title: const Text(
        "WSY",
        style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontFamily: "Signatra",
            letterSpacing: 2),
      ),
      centerTitle: true,
      bottom: bottom,
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
