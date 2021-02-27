import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/screens/appdrawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/screens/products/user_product_item.dart';
import 'addproducts.dart';
import 'imagepick.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImagePick()));
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('products')
              .where('uid', isEqualTo: user.firebaseUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final userProducts = snapshot.data.documents;
            return ListView.builder(
              itemCount: userProducts.length,
              itemBuilder: (context, index) {
                return UserProductItem(
                  id: userProducts[index].documentID,
                  imageUrl: userProducts[index]['imageUrl'],
                  title: userProducts[index]['title'],
                );
              },
            );
          },
        ));
  }
}
