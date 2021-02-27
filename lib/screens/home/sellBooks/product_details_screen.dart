import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_avenue_books/providers/product.dart';
import 'package:e_avenue_books/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  static const routeName = '/product-detail';

  const ProductDetailScreen({
    @required this.product,
    
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: product.imageurl,
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.lightGreenAccent,
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\₹${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      sellername: product.name,
                      sellerpic: product.profilePic,
                      selleruid: product.uid,
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
