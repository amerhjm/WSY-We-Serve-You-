import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wsy/Config/config.dart';
import 'package:wsy/Store/barberPage.dart';
import 'package:wsy/Store/derma.dart';
import 'package:wsy/Store/product_page.dart';
import 'package:wsy/Store/spa.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class bodyCare extends StatefulWidget {
  @override
  _bodyCare createState() => _bodyCare();
}

class _bodyCare extends State<bodyCare> {
  List categories = ['BodyCare', 'Spa', 'Barber', 'Derma'];

  @override
  Widget build(BuildContext context) {
    var soemhting = categories.asMap();
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            color: wsy.primaryColor,
          ),
          title: const Text(
            "WS",
            style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
                fontFamily: "Signatra",
                letterSpacing: 2),
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  collapsedHeight: 140,
                  flexibleSpace: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: wsy.primaryColor,
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("This is Body Care");
                            Route route =
                                MaterialPageRoute(builder: (c) => bodyCare());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'img/bodyCare.jpg',
                                  fit: BoxFit.fill,
                                ),
                                const Text("Body Care"),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is B");
                            Route route =
                                MaterialPageRoute(builder: (c) => derma());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'img/derma.jpg',
                                  fit: BoxFit.fill,
                                ),
                                const Text("Derma "),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is PhysicalTherapy");
                            Route route =
                                MaterialPageRoute(builder: (c) => derma());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'img/PT.jpg',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                const Text("PT"),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is B");
                            Route route =
                                MaterialPageRoute(builder: (c) => spa());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'img/spa.jpg',
                                  fit: BoxFit.fill,
                                ),
                                const Text("Spa"),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is B");
                            Route route =
                                MaterialPageRoute(builder: (c) => barberShop());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'img/barber.jpg',
                                  fit: BoxFit.fill,
                                ),
                                const Text("Barber"),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                      shrinkWrap: true,
                      reverse: false,
                      padding: EdgeInsets.all(10),
                      itemExtent: 100,
                    ),
                  ),
                ),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                    pinned: true, delegate: SearchBoxDelegate()),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Items")
                      .limit(15)
                      .orderBy("publishedDate", descending: true)
                      .where("serviceCategory", isEqualTo: "BodyCare")
                      .snapshots(),
                  builder: (context, dataSnapshot) {
                    return !dataSnapshot.hasData
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: circularProgress(),
                            ),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  dataSnapshot.data.docs[index].data());
                              return sourceInfo(model, context);
                            },
                            itemCount: dataSnapshot.data.docs.length,
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget gettingData() {
  return CustomScrollView(
    slivers: [
      SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Items")
            .limit(15)
            .orderBy("publishedDate", descending: true)
            .where("serviceCategory", isEqualTo: "BodyCare")
            .snapshots(),
        builder: (context, dataSnapshot) {
          return !dataSnapshot.hasData
              ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    ItemModel model = ItemModel.fromJson(
                        dataSnapshot.data.docs[index].data());
                    return sourceInfo(model, context);
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
        },
      ),
    ],
  );
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      // Route route =
      //     MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      // Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.teal,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 190.0,
        width: width,
        child: Container(
          child: Row(
            children: [
              Image.network(
                model.thumbnailUrl,
                width: 160.0,
                height: 160.0,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              model.title,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              model.shortInfo,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  const Text(
                                    r" Price: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Text(
                                    "₱ ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (model.serviceCategory == "BarberForMen" &&
                        wsy.sharedPreferences.getString(wsy.gender) ==
                            "male") ...[
                      const Text(
                        "Recommended By Gender",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                    if (model.serviceCategory == "BodyCare" &&
                        wsy.sharedPreferences.getString(wsy.gender) ==
                            "female") ...[
                      Text(
                        "Recommended By Gender",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                    if (model.serviceCategory == "Derma" &&
                        wsy.sharedPreferences.getString(wsy.gender) ==
                            "female") ...[
                      Text(
                        "Recommended By Gender",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],

                    if (model.serviceCategory == "Spa" &&
                        wsy.sharedPreferences.getString(wsy.gender) ==
                            "female") ...[
                      Text(
                        "Recommended By Gender",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],

                    if (model.serviceCategory == "Spa" &&
                        model.serviceAge == "34To49" &&
                        (wsy.sharedPreferences.getInt(wsy.age) >= 34 &&
                            wsy.sharedPreferences.getInt(wsy.age) < 49)) ...[
                      const Text(
                        "Recommended By Age",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],

                    if (model.serviceCategory == "PhysicalTherapy" &&
                        model.serviceAge == "50Plus" &&
                        (wsy.sharedPreferences.getInt(wsy.age) >= 50)) ...[
                      const Text(
                        "Recommended By Age",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],

                    if (model.serviceCategory == "PhysicalTherapy" &&
                        model.serviceAge == "34To49" &&
                        (wsy.sharedPreferences.getInt(wsy.age) >= 34 &&
                            wsy.sharedPreferences.getInt(wsy.age) < 49)) ...[
                      const Text(
                        "Recommended By Age",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                    Flexible(
                      child: Container(),
                    ),

                    //to implement the cart item aad/remove feature
                    Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                checkItemInCart(model.shortInfo, context);
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                removeCartFunction();
                                Route route = MaterialPageRoute(
                                    builder: (c) => bodyCare());
                                Navigator.pushReplacement(context, route);
                              },
                            ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 5.0,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  wsy.sharedPreferences.getStringList(wsy.userCartList).contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList = wsy.sharedPreferences.getStringList(wsy.userCartList);
  tempCartList.add(shortInfoAsID);

  wsy.firestore
      .collection(wsy.collectionUser)
      .doc(wsy.sharedPreferences.getString(wsy.userUID))
      .update({
    wsy.userCartList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

    wsy.sharedPreferences.setStringList(wsy.userCartList, tempCartList);
  });
}
