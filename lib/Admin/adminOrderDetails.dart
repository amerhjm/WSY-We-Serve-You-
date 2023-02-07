import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wsy/Config/config.dart';
import '../Address/address.dart';
import '../Models/address.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

String getOrderId = "";
var currentStatus;

class AdminOrderDetails extends StatefulWidget {
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({
    Key key,
    this.orderID,
    this.orderBy,
    this.addressID,
  }) : super(key: key);

  @override
  _AdminOrderDetails createState() => _AdminOrderDetails();
}

class _AdminOrderDetails extends State<AdminOrderDetails> {
  @override
  Widget build(BuildContext context) {
    gettUser(var Data) {
      // return dataMap['orderStatus'].toString();

      return Text(
        Data,
        style: const TextStyle(
            fontSize: 21, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }

    getOrderId = widget.orderID;
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
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: wsy.firestore
                .collection(wsy.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }

              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          AdminStatusBanner(
                            status: dataMap[wsy.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₱ " + dataMap[wsy.totalAmount].toString(),
                                style: TextStyle(
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
                              child: Row(
                                children: [
                                  const Text(
                                    "Order Status ",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  gettUser(dataMap['orderStatus'].toString())
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: wsy.firestore
                                .collection("Items")
                                .where("shortInfo",
                                    whereIn: dataMap[wsy.productID])
                                .get(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount: dataSnapshot.data.docs.length,
                                      data: dataSnapshot.data.docs,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: wsy.firestore
                                .collection(wsy.collectionUser)
                                .doc(widget.orderBy)
                                .collection(wsy.subCollectionAddress)
                                .doc(widget.addressID)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
                                      model: AddressModel.fromJson(
                                          snap.data.data()),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
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

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({Key key, this.status}) : super(key: key);

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
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Shipped " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
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

class AdminShippingDetails extends StatefulWidget {
  final AddressModel model;

  AdminShippingDetails({Key key, this.model}) : super(key: key);

  @override
  _AdminShippingDetails createState() => _AdminShippingDetails();
}

class _AdminShippingDetails extends State<AdminShippingDetails> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
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
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(widget.model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(widget.model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number",
                ),
                Text(widget.model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City",
                ),
                Text(widget.model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State",
                ),
                Text(widget.model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin Code",
                ),
                Text(widget.model.pincode),
              ]),
            ],
          ),
        ),
        DropDownFormField(
          titleText: "Control Order Status",
          hintText: "Order Status",
          value: currentStatus,
          onChanged: (value) {
            setState(() {
              currentStatus = value;
            });
          },
          dataSource: const [
            {
              "data": "Complete",
              "value": "Complete",
            },
            {"data": "Pending", "value": "Pending"},
            {
              "data": "On progress",
              "value": "onProgress",
            },
            {"data": "cancel", "value": "Cancel"},
          ],
          textField: "data",
          valueField: "value",
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              writeOrderDetailsForAdmin();
              writeOrderDetailsForUser();
            },
            child: Text("Submit Status"),
          ),
        ),
      ],
    );
  }

  // confirmParcelShifted(BuildContext context, String mOrderId) {
  //   // wsy.firestore
  //   //     .collection(wsy.collectionOrders)
  //   //     .doc(mOrderId)
  //   //     .delete();
  //   //
  //   // getOrderId = "";
  //   //
  //   // Route route = MaterialPageRoute(builder: (c) => UploadPage());
  //   // Navigator.pushReplacement(context, route);
  //   //
  //   // Fluttertoast.showToast(msg: "Parcel has been Shifted. Confirmed.");
  // }
  Future writeOrderDetailsForAdmin() async {
    await wsy.firestore
        .collection(wsy.collectionOrders)
        .doc(getOrderId)
        .update({
      "orderStatus": currentStatus,
    });
    print(getOrderId);
  }

  Future writeOrderDetailsForUser() async {
    await wsy.firestore
        .collection(wsy.collectionUser)
        .doc(getOrderId)
        .collection(wsy.collectionOrders)
        .doc(getOrderId)
        .update({
      "orderStatus": currentStatus,
    });
  }
}
