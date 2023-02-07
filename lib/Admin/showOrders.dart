import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wsy/Config/config.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({Key key}) : super(key: key);

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  String CurrentUser = wsy.auth.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wsy.primaryColor,
      appBar: AppBar(
        backgroundColor: wsy.primaryColor,
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  "ALl Orders",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: wsy.firestore
                      .collection("orders")
                      .where("ServiceProvider", isEqualTo: CurrentUser)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData == ConnectionState.waiting ||
                        snapshot.hasData == ConnectionState.active) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200.withOpacity(0.7),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        child: Image.network(snapshot.data
                                            .docs[index]['ServiceImageUrl']),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Title:"),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['ServiceTitle'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Description:"),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['ServiceItemDescription'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Price:"),
                                      Text(
                                        "${snapshot.data.docs[index]['ServiceItemPrice']} SAR",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Date:"),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['DateOrdredPlaced'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Time:"),
                                      Text(
                                        snapshot.data.docs[index]['Time'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Service Status:"),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['orderStatus'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Accept Service"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Reject Service"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
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
