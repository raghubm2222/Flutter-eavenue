//import 'dart:convert';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String author;
  final String branch;
  final String course;
  final String description;
  final String imageurl;
  final String name;
  final String price;
  final String profilePic;
  final String productID;
  final String title;
  final String uid;
  final String uploadedon;

  Product({
    @required this.author,
    @required this.branch,
    @required this.course,
    @required this.description,
    @required this.imageurl,
    @required this.name,
    @required this.price,
    @required this.profilePic,
    @required this.productID,
    @required this.title,
    @required this.uid,
    @required this.uploadedon,
  });
}
