import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_avenue_books/screens/chat/chats_lists.dart';
import 'package:e_avenue_books/screens/home/home.dart';
import 'package:e_avenue_books/screens/home/wishlist.dart';
import 'package:e_avenue_books/screens/products/imagepick.dart';
import 'package:e_avenue_books/screens/products/user_products_screen.dart';
import 'package:e_avenue_books/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_avenue_books/models/login_store.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Drawer(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: DrawerHeader(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'profileimage',
                      child: CircleAvatar(
                        radius: 50.0,
                        child: CachedNetworkImage(
                          imageUrl: loginStore.documentSnapshot['imageUrl'],
                        ),
                      ),
                    ),
                    Text(
                      loginStore.documentSnapshot['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      loginStore.firebaseUser.phoneNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.transparent),
            Hero(
              tag: 'Shop',
              child: ListTile(
                leading: Icon(
                  Icons.shop,
                ),
                title: Text('Shop'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.message,
              ),
              title: Text('Messages'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Messages()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
              ),
              title: Text('WishList'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishList()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
              ),
              title: Text('Sell Books'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImagePick()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.book,
              ),
              title: Text('Your Books'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProductsScreen()));
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    loginStore.signOut(context);
                  },
                  label: Text('Logout')),
            ),
          ],
        ),
      );
    });
  }
}
