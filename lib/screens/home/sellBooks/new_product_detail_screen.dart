import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/Constants.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/screens/chat/chat_screen.dart';
import 'package:e_avenue_books/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProductDetailScreen extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final bool isnew;
  static const routeName = '/product-detail';

  const NewProductDetailScreen({
    @required this.documentSnapshot,
    @required this.isnew,
  });

  Widget details(String title, String sub) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 5,
        ),
        Text(sub)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(documentSnapshot['title']),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 300,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: documentSnapshot['imageUrl'],
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.lightGreenAccent,
                  )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 10),
              details('Price:', documentSnapshot['price'].toString()),
              SizedBox(height: 10),
              details('Course:', documentSnapshot['course']),
              SizedBox(height: 10),
              details('Branch:', documentSnapshot['branch']),
              SizedBox(height: 10),
              details('Author:', documentSnapshot['author']),
              SizedBox(height: 10),
              details('Description:', documentSnapshot['description']),
              SizedBox(height: 10),
              details('Shared By:', ''),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(documentSnapshot['profilepic']),
                ),
                title: Text(documentSnapshot['name']),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                sellername: documentSnapshot['name'],
                sellerpic: documentSnapshot['profilepic'],
                selleruid: documentSnapshot['uid'],
              ),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              'Chat with Seller',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
