import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_avenue_books/models/theme.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/screens/auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        Provider.of<LoginStore>(context, listen: false).getUserData(context);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  final userRef = Firestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        //   child: FlatButton(onPressed: () async{await userRef.document(uid).setData({
        //   // 'uid': uid,
        //   // 'title': _title,
        //   // 'description': _description,
        //   // 'imageUrl': fileURL,
        //   // 'price': _price,
        //   // 'isFavorite': _isFavirate,
        //   // 'author': _author
        // })}, child: Text('Save Data')),
      ),
    );
  }
}
