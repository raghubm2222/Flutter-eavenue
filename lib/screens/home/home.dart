import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/screens/appdrawer/app_drawer.dart';
import 'package:e_avenue_books/screens/chat/chats_lists.dart';
import 'package:e_avenue_books/screens/home/sellBooks/sell_book.dart';
import 'package:e_avenue_books/screens/products/imagepick.dart';
import 'package:e_avenue_books/screens/products/user_products_screen.dart';
import 'package:e_avenue_books/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginstore, __) {
      return SellBookScreen(
        branch: loginstore.documentSnapshot['branch'],
      );
    });
  }
}
