import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsy/Config/config.dart';
import 'package:wsy/Store/barberPage.dart';
import 'package:wsy/Store/derma.dart';
import 'package:wsy/Store/product_page.dart';
import 'package:wsy/Store/spa.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import 'PhysicalTherapy.dart';
import 'bodyCare.dart';

double width;
String ch_sel = 'BodyCare';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List categories = [
    'Recommended',
    'BodyCare',
    'Spa',
    'Barber',
    'Derma',
    "PhysicalTherapy"
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    GestureDetector(
      onTap: () {
        ch_sel = 'BodyCare';
        print("This is Recommended");
        Route route = MaterialPageRoute(builder: (c) => bodyCare());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/bodyCare.jpg',
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
    GestureDetector(
      onTap: () {
        print("This is Recommended");
        ch_sel = 'Derma';
        Route route = MaterialPageRoute(builder: (c) => derma());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/derma.jpg',
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
    GestureDetector(
      onTap: () {
        print("This is Recommended");
        ch_sel = 'Derma';
        Route route = MaterialPageRoute(builder: (c) => derma());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/PT.jpg',
              height: 80,
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
    GestureDetector(
      onTap: () {
        print("This is Recommended");
        ch_sel = 'Spa';
        Route route = MaterialPageRoute(builder: (c) => spa());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/spa.jpg',
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
    GestureDetector(
      onTap: () {
        print("This is Recommended");
        ch_sel = 'Barber';
        Route route = MaterialPageRoute(builder: (c) => barberShop());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/barber.jpg',
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
    GestureDetector(
      onTap: () {
        ch_sel = 'BodyCare';
        print("This is Recommended");
        Route route = MaterialPageRoute(builder: (c) => bodyCare());
        Navigator.push(context, route);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/bodyCare.jpg',
              fit: BoxFit.fill,
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
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
                      shrinkWrap: false,
                      reverse: false,
                      padding: const EdgeInsets.all(10),
                      itemExtent: 100,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("This is Body Care");
                            ch_sel = 'BodyCare';
                            Route route =
                                MaterialPageRoute(builder: (c) => bodyCare());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is derma");
                            ch_sel = 'Derma';
                            Route route =
                                MaterialPageRoute(builder: (c) => derma());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is PhysicalTherapy");
                            ch_sel = 'PhysicalTherapy';
                            Route route = MaterialPageRoute(
                                builder: (c) => PhysicalTherapy());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is spa");
                            ch_sel = 'Spa';
                            Route route =
                                MaterialPageRoute(builder: (c) => spa());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("This is barberShop");
                            ch_sel = 'Barber';
                            Route route =
                                MaterialPageRoute(builder: (c) => barberShop());
                            Navigator.push(context, route);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                    pinned: false, delegate: SearchBoxDelegate()),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Items")
                      .limit(15)
                      // .where("field")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: circularProgress(),
                            ),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) =>
                                const StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              String ItemUID = snapshot.data.docs[index].id;
                              return InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (c) =>
                                          ProductPage(ItemUID: ItemUID));
                                  Navigator.pushReplacement(context, route);
                                },
                                splashColor: Colors.teal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: width,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          snapshot.data.docs[index]
                                              ['thumbnailUrl'],
                                          width: 160.0,
                                          height: 160.0,
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      snapshot.data.docs[index]
                                                          ['title'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      snapshot.data.docs[index]
                                                          ['shortInfo'],
                                                      style: const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              r" Price: ",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            const Text(
                                                              "SAR ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                            Text(
                                                              (snapshot.data.docs[
                                                                          index]
                                                                      ['price'])
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // if (snapshot
                                                      //         .data.docs[index]
                                                      //     ['rating']) ...[
                                                      //   Center(
                                                      //     child:
                                                      //         RatingBarIndicator(
                                                      //       itemSize: 25,
                                                      //       itemCount: 5,
                                                      //       rating: snapshot
                                                      //               .data
                                                      //               .docs[index]
                                                      //           ['price'],
                                                      //       itemBuilder:
                                                      //           (context,
                                                      //               index) {
                                                      //         switch (index) {
                                                      //           case 0:
                                                      //             return const Icon(
                                                      //               Icons
                                                      //                   .add, //sentiment_very_dissatisfied,
                                                      //               color: Colors
                                                      //                   .red,
                                                      //             );
                                                      //           case 1:
                                                      //             return const Icon(
                                                      //               Icons
                                                      //                   .add, //sentiment_dissatisfied,
                                                      //               color: Colors
                                                      //                   .redAccent,
                                                      //             );
                                                      //           case 2:
                                                      //             return const Icon(
                                                      //               Icons
                                                      //                   .add, //sentiment_neutral,
                                                      //               color: Colors
                                                      //                   .amber,
                                                      //             );
                                                      //           case 3:
                                                      //             return const Icon(
                                                      //               Icons
                                                      //                   .add, //sentiment_satisfied,
                                                      //               color: Colors
                                                      //                   .lightGreen,
                                                      //             );
                                                      //           case 4:
                                                      //             return const Icon(
                                                      //               Icons
                                                      //                   .add, //sentiment_very_satisfied,
                                                      //               color: Colors
                                                      //                   .green,
                                                      //             );
                                                      //         }
                                                      //       },
                                                      //     ),
                                                      //   )
                                                      // ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
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
                              );
                            },
                            itemCount: snapshot.data.docs.length,
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

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 10.0,
              color: Colors.grey[200]),
        ]),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Future testInsert() async {
  FirebaseFirestore.instance.collection("training").add({
    "age": wsy.sharedPreferences.getInt(wsy.age),
    "gender": wsy.sharedPreferences.getString(wsy.gender),
    "choice": ch_sel,
  });
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  wsy.sharedPreferences.getStringList(wsy.userCartList).contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList = wsy.sharedPreferences.getStringList(wsy.userCartList);
  tempCartList.add(shortInfoAsID);

  testInsert();

  wsy.firestore
      .collection(wsy.collectionUser)
      .doc(wsy.sharedPreferences.getString(wsy.userUID))
      .update({
    wsy.userCartList: tempCartList,
  }).then((v) {
    //...learning

    Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

    wsy.sharedPreferences.setStringList(wsy.userCartList, tempCartList);
  });
}
