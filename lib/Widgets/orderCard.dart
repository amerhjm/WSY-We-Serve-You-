import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wsy/Config/config.dart';
import '../Models/item.dart';
import '../Orders/OrderDetailsPage.dart';
import '../Store/storehome.dart';

int counter = 0;
var solo;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String orderRating;
  final String date;
  final String time;

  const OrderCard({
    Key key,
    this.itemCount,
    this.orderRating,
    this.data,
    this.orderID,
    this.date,
    this.time,
    asdf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        route = MaterialPageRoute(
            builder: (c) =>
                OrderDetails(orderID: orderID, rating: orderRating));
        // if (counter == 0) {
        //   counter = counter + 1;
        //   route =
        //       MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID, rating: orderRating));
        // }
        Navigator.push(context, route);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: wsy.primaryColor,
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());
            solo = data[index].id;
            return sourceOrderInfo(model, context, solo);
          },
        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context, String solo,
    {Color background}) {
  width = MediaQuery.of(context).size.width;

  //
  // wsy.sharedPreferences.setString("solo", solo);
  // double conver = model.rating;
  //
  // print("This is conver ${conver}");

  return Container(
    color: Colors.grey[100],
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl,
          width: 180.0,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.longDescription,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            const Text(
                              r"Total Price: ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              "₱ ",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16.0),
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
              Row(
                children: [
                  Center(
                    child: RatingBarIndicator(
                      itemSize: 25,
                      itemCount: 5,
                      rating: conver ?? 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
              ),
              const Divider(
                height: 5.0,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
