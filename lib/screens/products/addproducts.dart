import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../Constants.dart';
import 'user_products_screen.dart';

class AddProductScreen extends StatefulWidget {
  final File imageFile;

  const AddProductScreen({Key key, @required this.imageFile}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

final userRef = Firestore.instance.collection('products');

class _AddProductScreenState extends State<AddProductScreen> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  var courseList = [
    "Bachelor Engineeing",
    "Diploma",
  ];

  String _title;
  String _author;
  String _description;
  String _branch;
  int _price;
  String _course;

  submit(BuildContext context, String uid, String name, String profilepic) {
    bool isvalid = _formKey.currentState.validate();
    bool isCouse = _course != null;
    bool isbranch = _branch != null;
    if (isvalid & isbranch && isCouse) {
      _formKey.currentState.save();
      uploadFile(widget.imageFile, uid, name, profilepic);
    } else if (!isCouse) {
      toast("Select Course", context);
    } else if (!isbranch) {
      toast("Select Branch", context);
    }
  }

  Future uploadFile(
      File file, String uid, String name, String profilepic) async {
    setState(() {
      isloading = true;
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('productimages/$uid-${DateTime.now()}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) async {
      await userRef.add({
        'uid': uid,
        'name': name,
        'title': _title,
        'author': _author,
        'course': _course,
        'branch': _branch,
        'price': _price,
        'description': _description,
        'profilepic': profilepic,
        'imageUrl': fileURL,
        'uploadedOn': DateTime.now(),
      }).then((_) {
        setState(() {
          isloading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserProductsScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginStore>(context);
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Share Book"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  DropdownButtonFormField<String>(
                    validator: (_) {
                      if (_course == null) {
                        return "Select Course";
                      }
                      return null;
                    },
                    decoration: InputDecoration(),
                    hint: Text("Select a Course"),
                    isExpanded: true,
                    items: courseList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _course = value;
                      });
                    },
                  ),
                  sizedBox,
                  DropdownButtonFormField<String>(
                    validator: (_) {
                      if (_branch == null) {
                        return "Select Branch";
                      }
                      return null;
                    },
                    decoration: InputDecoration(),
                    hint: Text("Select a Branch"),
                    isExpanded: true,
                    items: branchesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _branch = value;
                      });
                    },
                  ),
                  sizedBox,
                  TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter title of the Book';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                    onSaved: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter Author Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Author Name",
                    ),
                    onSaved: (value) {
                      setState(() {
                        _author = value;
                      });
                    },
                  ),
                  sizedBox,
                  TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter Price';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Price',
                      suffix: Text("₹"),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      setState(() {
                        _price = int.parse(value);
                      });
                    },
                  ),
                  sizedBox,
                  TextFormField(
                    validator: (value) {
                      if (value.length < 10) {
                        return 'Description Should be More than 10 Charecters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    onSaved: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
          child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 2.0,
              onPressed: () {
                submit(
                    context,
                    user.firebaseUser.uid,
                    user.documentSnapshot['name'],
                    user.documentSnapshot['imageUrl']);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     AppRoute.homeScreen, (Route<dynamic> route) => false);
              },
              label: Text(
                "Share",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              )),
        ),
      ),
    );
  }
}
