import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsy/Config/config.dart';

import '../Counters/changeAddresss.dart';
import '../Models/address.dart';
import '../Orders/placeOrderPayment.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/wideButton.dart';
import 'addAddress.dart';

class Address extends StatefulWidget {
  final String ImageUrl;
  final String ItemTitle;
  final String ItemDescription;
  final String ItemPrice;
  final String ServiceProviderUpload;
  const Address(
      {Key key,
      this.ImageUrl,
      this.ItemTitle,
      this.ItemDescription,
      this.ItemPrice,
      this.ServiceProviderUpload})
      : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String currentUser = wsy.auth.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: wsy.firestore
                      .collection("users")
                      .doc(currentUser)
                      .collection("userAddress")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.docs.isEmpty
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressId: snapshot.data.docs[index].id,
                                    ImageUrl: widget.ImageUrl,
                                    ItemDescription: widget.ItemDescription,
                                    ItemPrice: widget.ItemPrice,
                                    ItemTitle: widget.ItemTitle,
                                    ServiceProviderUpload:
                                        widget.ServiceProviderUpload,
                                    model: AddressModel.fromJson(
                                      snapshot.data.docs[index].data(),
                                    ),
                                  );
                                },
                              );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add New Address"),
          backgroundColor: Colors.teal,
          icon: const Icon(Icons.add_location),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.teal.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            Text("No shipment address has been saved."),
            Text(
                "Please add your shipment Address so that we can deliever product."),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  final String ImageUrl;
  final String ItemTitle;
  final String ItemDescription;
  final String ItemPrice;
  final String ServiceProviderUpload;

  AddressCard({
    Key key,
    this.model,
    this.currentIndex,
    this.addressId,
    this.totalAmount,
    this.value,
    this.ImageUrl,
    this.ItemDescription,
    this.ItemPrice,
    this.ItemTitle,
    this.ServiceProviderUpload,
  }) : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.teal.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
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
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                addressId: widget.addressId,
                                totalAmount: widget.totalAmount,
                                ImageUrl: widget.ImageUrl,
                                ItemDescription: widget.ItemDescription,
                                ItemPrice: widget.ItemPrice,
                                ItemTitle: widget.ItemTitle,
                                ServiceProviderUpload:
                                    widget.ServiceProviderUpload,
                              ));
                      Navigator.push(context, route);
                      print(widget.ImageUrl);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg, String mes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
