import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginstore, __) {
      return Scaffold(
          appBar: AppBar(title: Text('Wishlist')),
          body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(loginstore.firebaseUser.uid)
                .collection('wishlist')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final doc = snapshot.data.documents;
              return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doc[i]['imageUrl']),
                    ),
                    title: Text(doc[i]['title']),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Firestore.instance
                              .collection('users')
                              .document(loginstore.firebaseUser.uid)
                              .collection('wishlist')
                              .document(doc[i].documentID)
                              .delete();
                        }),
                  );
                },
              );
            },
          ));
    });
  }
}
