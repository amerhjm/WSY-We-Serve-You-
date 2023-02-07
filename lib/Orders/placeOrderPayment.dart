import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wsy/Config/config.dart';
import 'package:wsy/DialogBox/loadingDialog.dart';
import 'package:wsy/main.dart';
import 'package:intl/intl.dart' as dateFormat;
import '../Store/PhysicalTherapy.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final String ImageUrl;
  final String ItemDescription;
  final String ItemPrice;
  final String ItemTitle;
  final String ServiceProviderUpload;

  PaymentPage({
    Key key,
    this.addressId,
    this.totalAmount,
    this.ImageUrl,
    this.ItemDescription,
    this.ItemPrice,
    this.ItemTitle,
    this.ServiceProviderUpload,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String CurrentUser = wsy.auth.currentUser.uid;
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: wsy.primaryColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("img/cash.png"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text(
                  "Pick Date And Time To checkout",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        _dateController.text = DateFormat.yMd().format(selectedDate);
        print(_dateController.text = DateFormat.yMd().format(selectedDate));
        var _setDate = _dateController.text;
        _selectTime(context, _setDate);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context, _setDate) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _timeController.text = _time;
        print(_timeController.text = _time);
        var _setTime = _timeController.text;
        addOrderDetails(_setTime, _setDate);
      });
    }
  }

  addOrderDetails(_setTime, _setDate) {
    showDialog(
        context: context,
        builder: (_) => const LoadingAlertDialog(
              message: "Uploading Data",
            ));
    wsy.firestore.collection("orders").add({
      wsy.addressID: widget.addressId,
      "rating": "",
      "orderStatus": "Pending",
      "Date": _setDate,
      "Time": _setTime,
      "UserOrdred": CurrentUser,
      "ServiceProvider": widget.ServiceProviderUpload,
      "ServiceImageUrl": widget.ImageUrl,
      "ServiceItemDescription": widget.ItemDescription,
      "ServiceItemPrice": widget.ItemPrice,
      "ServiceTitle": widget.ItemTitle,
      "DateOrdredPlaced":
          dateFormat.DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      wsy.paymentDetails: "Cash on Delivery",
    }).then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Congratulations, your Order has been placed successfully.");
      Route route = MaterialPageRoute(builder: (c) => MyApp());
      Navigator.pushReplacement(context, route);
    });
  }
}
