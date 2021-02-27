import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';

import '../../Constants.dart';

class GetProfile extends StatefulWidget {
  final FirebaseUser user;

  const GetProfile({Key key, @required this.user}) : super(key: key);
  @override
  _GetProfileState createState() => _GetProfileState();
}

class _GetProfileState extends State<GetProfile> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String _gender;
  String _cource;
  String _branch;
  final _picker = ImagePicker();
  bool isloading = false;
  File _image;
  Position _currentPosition;
  final userRef = Firestore.instance.collection('users');
  var courceList = [
    "Bachelor Engineeing",
    "Diploma",
  ];

  Future chooseFile(ImageSource imageSource) async {
    await _picker
        .getImage(source: imageSource, maxHeight: 250.0, maxWidth: 250.0)
        .then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  Future uploadFile(File file) async {
    setState(() {
      isloading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/profilePicturs/${widget.user.uid}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      uploaddata(fileURL);
    });
  }

  uploaddata(String imageUrl) {
    userRef.document(widget.user.uid).setData({
      "id": widget.user.uid,
      "name": name,
      "phoneNumber": widget.user.phoneNumber,
      "gender": _gender,
      "createdon": DateTime.now().toString(),
      "imageUrl": imageUrl,
      "branch": _branch,
      "cource": _cource,
      "location":
          GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
    }).then((value) async {
      DocumentSnapshot doc = await userRef.document(widget.user.uid).get();
      Navigator.pop(context, doc);
    });
  }

  submit(BuildContext context) {
    final nameIsValid = _formKey.currentState.validate();
    bool isgender = _gender != null;
    bool isbranch = _branch != null;
    bool iscource = _cource != null;
    if (nameIsValid && isbranch && iscource && isgender) {
      _formKey.currentState.save();
      if (_image == null) {
        uploaddata('');
      } else {
        uploadFile(_image);
      }
    } else if (!iscource) {
      toast("Pick Your Cource", context);
    } else if (!isbranch) {
      toast("Pick Your Branch", context);
    } else if (!isgender) {
      toast("Select Gender", context);
    }
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

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('Complete Your Profile',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
          centerTitle: true,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
          child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 2.0,
              onPressed: () {
                submit(context);
              },
              label: Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: CircleAvatar(
                      radius: 70.0,
                      child: _image == null
                          ? Icon(Icons.camera_alt)
                          : Image.file(_image),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: headdingtextStyle),
                      TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Enter Your Name";
                          } else if (value.length < 4) {
                            return "Name must be more than 5 charecters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Your Name",
                            hintStyle: hinttextStyle),
                        onSaved: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      sizedBox,
                      Text('Cource', style: headdingtextStyle),
                      DropdownButtonFormField<String>(
                        validator: (_) {
                          if (_cource == null) {
                            return "Select Course";
                          }
                          return null;
                        },
                        decoration: InputDecoration(),
                        hint: Text(
                          "Select Cource",
                          style: dropdowntextStyle,
                        ),
                        isExpanded: true,
                        items: courceList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _cource = value;
                          });
                        },
                      ),
                      sizedBox,
                      Text('Branch', style: headdingtextStyle),
                      DropdownButtonFormField<String>(
                        validator: (_) {
                          if (_branch == null) {
                            return "Select Branch";
                          }
                          return null;
                        },
                        decoration: InputDecoration(),
                        hint: Text("Select a Branch", style: dropdowntextStyle),
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
                      Text(
                        'Gender',
                        style: headdingtextStyle,
                      ),
                      RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        items: status,
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                          textPosition: RadioButtonTextPosition.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
