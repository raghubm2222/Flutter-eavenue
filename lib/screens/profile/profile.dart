import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/screens/profile/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginstore, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Your Profile'),
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return EditProfile(
                          user: loginstore.firebaseUser,
                          documentSnapshot: loginstore.documentSnapshot,
                        );
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white70,
                ),
                label: Text('Edit', style: TextStyle(color: Colors.white70)),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Hero(
                  tag: 'profileimage',
                  child: CircleAvatar(
                      radius: 70.0,
                      backgroundImage: NetworkImage(
                          loginstore.documentSnapshot['imageUrl'])),
                ),
                SizedBox(height: 10),
                Text(loginstore.documentSnapshot['name'],
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(
                  'Memeber :  ${DateFormat.yMMM().format(DateTime.parse(loginstore.documentSnapshot['createdon']))}',
                  style: TextStyle(fontSize: 12.0),
                ),
                ListTile(
                  leading: Text(
                    'Phone',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    loginstore.firebaseUser.phoneNumber,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'Course',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    loginstore.documentSnapshot['cource'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'Branch',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    loginstore.documentSnapshot['branch'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'Gender',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    loginstore.documentSnapshot['gender'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Spacer(),
                FloatingActionButton.extended(
                    onPressed: () {
                      loginstore.signOut(context);
                    },
                    label: Text('Logout')),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
