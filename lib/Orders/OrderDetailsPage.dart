import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Address/address.dart';
import '../Config/config.dart';
import '../Models/address.dart';
import '../Widgets/customTextField.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import '../main.dart';

String getOrderId = "";
var conver;
var dataGetting = '';
var gettingCurrentItemId = [];
TextEditingController feedBack = TextEditingController();
var asdf = '';

class OrderDetails extends StatelessWidget {
  final String orderID;
  final String rating;

  OrderDetails({
    Key key,
    this.orderID,
    this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            color: wsy.primaryColor,
          ),
          centerTitle: true,
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: wsy.firestore
                .collection(wsy.collectionUser)
                .doc(wsy.sharedPreferences.getString(wsy.userUID))
                .collection(wsy.collectionOrders)
                .doc(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
                gettingCurrentItemId = dataMap[wsy.productID];
              }
              return snapshot.hasData
                  ? Column(
                      children: [
                        StatusBanner(
                          status: dataMap[wsy.isSuccess],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "₱ " + dataMap[wsy.totalAmount].toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Service Date " + dataMap['Date'].toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Service Time " + dataMap['Time'].toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  "Order Status ",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  dataGetting =
                                      dataMap['orderStatus'].toString(),
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Order ID: " + getOrderId),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Ordered at: " +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        const Divider(
                          height: 2.0,
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: wsy.firestore
                              .collection("Items")
                              .where("shortInfo",
                                  whereIn: dataMap[wsy.productID])
                              .get(),
                          builder: (c, dataSnapshot) {
                            Map dataMapp;
                            if (dataSnapshot.hasData) {
                              print(dataMapp);
                            }

                            return dataSnapshot.hasData
                                ? Column(
                                    children: [
                                      OrderCard(
                                        itemCount:
                                            dataSnapshot.data.docs.length,
                                        data: dataSnapshot.data.docs,
                                        asdf: dataSnapshot.data.docs,
                                        // asdf: dataSnapshot.data.docs[dataMap[wsy.productID]].id,
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                        const Divider(
                          height: 2.0,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: wsy.firestore
                              .collection(wsy.collectionUser)
                              .doc(wsy.sharedPreferences.getString(wsy.userUID))
                              .collection(wsy.subCollectionAddress)
                              .doc(dataMap[wsy.addressID])
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? ShippingDetails(
                                    model:
                                        AddressModel.fromJson(snap.data.data()),
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  const StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
        color: wsy.primaryColor,
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: const Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Placed " + msg,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  const ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Shipment Details:",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin Code",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: RatingBar.builder(
            initialRating: 3,
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
              }
            },
            onRatingUpdate: (rating) {
              print(rating);
              confirmedUserOrderReceived(context, getOrderId, rating);
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        if (dataGetting == 'Complete') ...[
          CustomTextField(
            controller: feedBack,
            data: Icons.comment,
            hintText: "Feedback",
            isObsecure: false,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => submitFeedback(context, getOrderId),
              child: const Text("Submit Feedback"),
            ),
          ),
        ],
        if (dataGetting == 'Pending') ...[
          Center(
            child: ElevatedButton(
              onPressed: () => cancelOrder(context, getOrderId),
              child: const Text("Cancel order"),
            ),
          ),
        ],
      ],
    );
  }

  // whereIn: snapshot.data.docs[index]
  // [wsy.productID]
  submitFeedback(BuildContext context, String mOrderId) async {
    var currentTmie = DateFormat.yMd().format(DateTime.now());
    print(wsy.sharedPreferences.getString(wsy.productID));

    //
    // Future<String> get_data(DocumentReference doc_ref) async {
    //
    //   DocumentSnapshot docSnap= wsy.firestore
    //       .collection("Items")
    //       .where("shortInfo",
    //       whereIn: gettingCurrentItemId)
    //       .get();
    //   var doc_id2 = docSnap.reference.id;
    //   print(doc_id2);
    //
    //   return doc_id2;
    // }

    var doc_ref = await wsy.firestore
        .collection("Items")
        .where("shortInfo", whereIn: gettingCurrentItemId)
        .get();
    doc_ref.docs.forEach((result) {
      print(result.id);

//To retrieve the string
      if (feedBack.text != '') {
        wsy.firestore
            .collection("Items")
            .doc(result.id)
            .collection("feedback")
            .add({
          "feedback": feedBack.text.trim(),
          "currentTime": currentTmie.toString(),
          "itemId": result.id,
          "name": model.name.toString().trim(),
        });
        print(wsy.sharedPreferences.getString("solo"));
        feedBack.clear();
        Fluttertoast.showToast(msg: "Feedback was added");
      } else {
        Fluttertoast.showToast(msg: "Please write Feedback");
      }
    });
  }

  cancelOrder(BuildContext context, String mOrderId) {
    if (dataGetting != null) {
      wsy.firestore
          .collection(wsy.collectionUser)
          .doc(wsy.sharedPreferences.getString(wsy.userUID))
          .collection(wsy.collectionOrders)
          .doc(mOrderId)
          .update({
        "orderStatus": "Canceled",
      });
      // StreamBuilder<QuerySnapshot>(
      //   stream: wsy.firestore
      //       .collection(wsy.collectionUser)
      //       .doc(wsy.sharedPreferences.getString(wsy.userUID))
      //       .collection(wsy.collectionOrders)
      //       .snapshots(),
      //   builder: (c, snapshot) {
      //     return snapshot.hasData
      //         ? ListView.builder(
      //             itemCount: snapshot.data.docs.length,
      //             itemBuilder: (c, index) {
      //               return FutureBuilder<QuerySnapshot>(
      //                 future: FirebaseFirestore.instance
      //                     .collection("Items")
      //                     .where("shortInfo",
      //                         whereIn: snapshot.data.docs[index]
      //                             [wsy.productID])
      //                     .get(),
      //                 builder: (c, snap) {
      //                   var asdf = snapshot.data.docs[index].id;
      //                   return snap.hasData
      //                       ? OrderCard(
      //                           itemCount: snap.data.docs.length,
      //                           data: snap.data.docs,
      //                           orderID: snapshot.data.docs[index].id,
      //                         )
      //                       : Center(
      //                           child: circularProgress(),
      //                         );
      //                 },
      //               );
      //             },
      //           )
      //         : Center(
      //             child: circularProgress(),
      //           );
      //   },
      // );
    }
    // var gettingItemId = wsy.sharedPreferences.getString("short");
    // print(
    //     "This is data ${wsy.sharedPreferences.getString(wsy.productID)}");
    // var trying = wsy.firestore
    //     .collection("Items")
    //     .where("shortInfo",
    //         whereIn: wsy.sharedPreferences
    //             .getStringList(wsy.userCartList))
    //     .snapshots();
    // trying.forEach((element) {
    //   element.docs.asMap();
    //   print("this is the trying ${element.docs.asMap()}");
    // });
    // Fluttertoast.showToast(msg: "Order has been Canceled.");
  }

  confirmedUserOrderReceived(
      BuildContext context, String mOrderId, double rating) {
    wsy.firestore
        .collection(wsy.collectionUser)
        .doc(wsy.sharedPreferences.getString(wsy.userUID))
        .collection(wsy.collectionOrders)
        .doc(mOrderId)
        .update({
      "rating": rating,
    });
    print("this is mOrddrI ${mOrderId}");
    StreamBuilder<QuerySnapshot>(
      stream: wsy.firestore
          .collection(wsy.collectionUser)
          .doc(wsy.sharedPreferences.getString(wsy.userUID))
          .collection(wsy.collectionOrders)
          .snapshots(),
      builder: (c, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Items")
                        .where("shortInfo",
                            whereIn: snapshot.data.docs[index][wsy.productID])
                        .get(),
                    builder: (c, snap) {
                      var asdf = snapshot.data.docs[index].id;
                      print("This is inside ${asdf}");
                      wsy.sharedPreferences.setString("keyy", asdf.toString());
                      return snap.hasData
                          ? OrderCard(
                              itemCount: snap.data.docs.length,
                              data: snap.data.docs,
                              orderID: snapshot.data.docs[index].id,
                            )
                          : Center(
                              child: circularProgress(),
                            );
                    },
                  );
                },
              )
            : Center(
                child: circularProgress(),
              );
      },
    );

    var gettingItemId = wsy.sharedPreferences.getString("short");
    print("This is data ${wsy.sharedPreferences.getString(wsy.productID)}");
    var trying = wsy.firestore
        .collection("Items")
        .where("shortInfo",
            whereIn: wsy.sharedPreferences.getStringList(wsy.userCartList))
        .snapshots();
    trying.forEach((element) {
      element.docs.asMap();
      print("this is the trying ${element.docs.asMap()}");
    });
    print("this is the trying ${trying}");

    wsy.firestore
        .collection("Items")
        .doc(wsy.sharedPreferences.getString("solo"))
        .update({
      "rating": rating,
    });
    Fluttertoast.showToast(msg: "Order has been Received. Confirmed.");
  }
}
