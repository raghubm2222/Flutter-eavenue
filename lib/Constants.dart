import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

var searchDecoration = InputDecoration(
  hintText: 'Search books',
  hintStyle: TextStyle(color: Colors.grey),
  border: InputBorder.none,
  prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {}),
  filled: true,
  fillColor: Colors.white,
);

class ClearContainer extends StatelessWidget {
  final Function onTap;
  const ClearContainer({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        height: 48,
        color: Colors.white,
        child: Icon(Icons.cancel),
      ),
    );
  }
}

class FilterSortBtn extends StatelessWidget {
  final Function ontap;
  final String title;
  final IconData iconData;
  const FilterSortBtn({
    Key key,
    @required this.ontap,
    @required this.title,
    @required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(iconData), Text(title)],
        ),
      ),
    );
  }
}

var branchesList = [
  "Mechanical Engineeing",
  "Civil Engineering",
  "Electronics and Engineering",
  "Eelctronics & Electrical Engineeering",
  "Computer Science and Engineering",
  "Aeronautical Engineering",
  "Automobile Engineering",
  "Chemical Engineering",
  "Industrial & Production Engineering",
  "Telecommunication Engineering",
  "Information Science & Engineering",
  "Others"
];

var sortlist = ['Newest Frist', 'Price Low to Heigh', 'Price Heigh to Low'];
List<String> status = ["Male", "Female"];

toast(String message, BuildContext context) {
  Toast.show(
    message,
    context,
    duration: Toast.LENGTH_SHORT,
    gravity: Toast.CENTER,
    backgroundColor: Colors.red,
  );
}

var headdingtextStyle =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
var hinttextStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
var dropdowntextStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
var sizedBox = SizedBox(height: 15.0);
