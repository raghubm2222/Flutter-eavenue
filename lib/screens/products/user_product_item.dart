import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_avenue_books/providers/products.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  void initState() {
    super.initState();
  }
  Future<void> _showMyDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Remove Book'),
          content: Text('$title will be Deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await Firestore.instance
                    .collection('products')
                    .document(widget.id)
                    .delete()
                    .then((value) {
                  Navigator.pop(context);
                  
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        title: Text(widget.title),
        leading: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightGreenAccent,
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fitHeight,
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  //     arguments: widget.id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showMyDialog(widget.title);
                  // try {
                  //   // await Provider.of<Products>(context, listen: false)
                  //   //     .deleteProduct(widget.id);
                  // } catch (error) {
                  //   scaffold.showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //         'Deleting failed!',
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //   );
                  // }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
