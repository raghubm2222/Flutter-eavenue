import 'dart:io';

import 'package:e_avenue_books/screens/products/addproducts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  final _picker = ImagePicker();
  File _image;
  Future chooseFile(ImageSource imageSource) async {
    await _picker
        .getImage(source: imageSource, maxHeight: 500.0, maxWidth: 500.0)
        .then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Select Image'),
          content: Text('Choose Image From'),
          actions: <Widget>[
            FlatButton(
              child: Text('Camera'),
              onPressed: () {
                chooseFile(ImageSource.camera).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
            FlatButton(
              child: Text('Gallery'),
              onPressed: () {
                chooseFile(ImageSource.gallery).then((value) {
                  Navigator.of(context).pop();
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Image'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _showMyDialog();
          },
          child: Container(
            height: 500,
            width: 500,
            child: _image == null
                ? Image.asset(
                    "assets/images/image.png",
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    _image,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
        child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 2.0,
            onPressed: _image == null
                ? () {
                    _showMyDialog();
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddProductScreen(imageFile: _image),
                      ),
                    );
                  },
            label: Text(
              _image == null ? "Pick Image" : "Next",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            )),
      ),
    );
  }
}
