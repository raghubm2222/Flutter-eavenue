import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/providers/product.dart';
import 'package:e_avenue_books/screens/home/sellBooks/new_product_detail_screen.dart';
import 'package:e_avenue_books/screens/home/sellBooks/product_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsTile extends StatefulWidget {
  const ProductsTile({
    Key key,
    @required this.product,
    @required this.firebaseUser,
  }) : super(key: key);

  final Product product;
  final FirebaseUser firebaseUser;

  @override
  _ProductsTileState createState() => _ProductsTileState();
}

class _ProductsTileState extends State<ProductsTile> {
  bool isFavorite = false;
  getfavorite() async {
    final doc = await Firestore.instance
        .collection('users')
        .document(widget.firebaseUser.uid)
        .collection('wishlist')
        .document(widget.product.productID)
        .get();
    setState(() {
      isFavorite = doc.exists;
    });
  }

  @override
  void initState() {
    getfavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: widget.product)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 6.0)],
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        height: 160,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              height: 100,
              width: 100,
              child: CachedNetworkImage(
                imageUrl: widget.product.imageurl,
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.lightGreenAccent,
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fitHeight,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (widget.product.title.length > 35) ...[
                  Text(
                    '${widget.product.title.substring(0, 35)}-',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '-${widget.product.title.substring(35)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                if (widget.product.title.length < 35) ...[
                  Text(
                    '${widget.product.title}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                Text(widget.product.author),
                Text("₹${widget.product.price}"),
                Consumer<LoginStore>(
                  builder: (_, loginStore, __) {
                    return FutureBuilder(
                      future: Firestore.instance
                          .collection('users')
                          .document(loginStore.firebaseUser.uid)
                          .collection('wishlist')
                          .getDocuments(),
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: Icon(Icons.people_outline),
                          onPressed: () async {},
                        );
                      },
                    );
                  },
                ),
                Consumer<LoginStore>(
                  builder: (_, loginstore, __) {
                    return GestureDetector(
                      onTap: () async {
                        final doc = await Firestore.instance
                            .collection('products')
                            .document(widget.product.productID)
                            .get();
                        Firestore.instance
                            .collection('users')
                            .document(loginstore.firebaseUser.uid)
                            .collection('wishlist')
                            .document(widget.product.productID)
                            .setData(doc.data);
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(1000),
                        elevation: 2.0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
