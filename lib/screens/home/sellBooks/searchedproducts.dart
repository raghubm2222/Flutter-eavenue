import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_avenue_books/providers/product.dart';
import 'package:e_avenue_books/screens/home/sellBooks/product_details_screen.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget {
  const SearchProduct({
    Key key,
    @required this.filteresProducts,
    @required this.isNew,
  }) : super(key: key);

  final List<Product> filteresProducts;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteresProducts.length,
      // ignore: missing_return
      itemBuilder: (context, i) {
        if (filteresProducts.isEmpty) {
          return Center(
            child: Text('Enter Keywords to search'),
          );
        }
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: filteresProducts[i],
                ),
              ),
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
                  height: 120,
                  width: 120,
                  child: CachedNetworkImage(
                    imageUrl: filteresProducts[i].imageurl,
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
                    Text(
                      filteresProducts[i].title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(filteresProducts[i].author),
                    Text("₹${filteresProducts[i].price}"),
                    Material(
                      borderRadius: BorderRadius.circular(1000),
                      elevation: 2.0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
