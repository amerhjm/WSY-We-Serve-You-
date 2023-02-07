import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wsy/Address/address.dart';
import 'package:wsy/Config/config.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';

class ProductPage extends StatefulWidget {
  final String ItemUID;

  ProductPage({this.ItemUID});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: wsy.firestore
                      .collection("Items")
                      .doc(widget.ItemUID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String ServiceProviderUpload =
                        snapshot.data.get('serviceProviderID');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Image.network(
                                  snapshot.data.get('thumbnailUrl').toString()),
                            ),
                            Container(
                              color: Colors.grey[300],
                              child: const SizedBox(
                                height: 1.0,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.get('title').toString(),
                                  style: boldTextStyle,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  snapshot.data.get('shortInfo').toString(),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "SAR ${snapshot.data.get('price').toString()}",
                                  style: boldTextStyle,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (_) => Address(
                                          ItemDescription:
                                              snapshot.data.get('shortInfo'),
                                          ImageUrl:
                                              snapshot.data.get('thumbnailUrl'),
                                          ItemPrice: snapshot.data
                                              .get('price')
                                              .toString(),
                                          ItemTitle: snapshot.data.get('title'),
                                          ServiceProviderUpload:
                                              ServiceProviderUpload,
                                        ));
                                Navigator.push(context, route);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: wsy.primaryColor,
                                ),
                                width: MediaQuery.of(context).size.width - 40.0,
                                height: 50.0,
                                child: const Center(
                                  child: Text(
                                    "Book Service",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 600,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: wsy.firestore
                                .collection("Items")
                                .doc(widget.ItemUID)
                                .collection("feedback")
                                .snapshots(),
                            builder: (c, snapshott) {
                              return !snapshot.hasData
                                  ? Center(
                                      child: circularProgress(),
                                    )
                                  : ListView.builder(
                                      itemCount: snapshott.data.docs.length,
                                      itemBuilder: (c, index) {
                                        DocumentSnapshot ds =
                                            snapshott.data.docs[index];
                                        return Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ds['name'].toString(),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                ds['feedback'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              ),
                                              const Divider(
                                                color: Colors.black45,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
