import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_avenue_books/screens/appdrawer/app_drawer.dart';
import 'package:e_avenue_books/screens/chat/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginstore, __) {
        return Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Navigator.pop(context)),
            title: Text('Messages'),
          ),
          body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(loginstore.firebaseUser.uid)
                .collection('messageslist')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final doc = snapshot.data.documents;
              return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ChatScreen(
                              sellername: doc[index]['recivername'],
                              sellerpic: doc[index]['reciverpic'],
                              selleruid: doc[index]['reciveruid'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: CachedNetworkImage(
                            imageUrl: doc[index]['reciverpic'],
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.lightGreenAccent,
                            )),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        title: Text(doc[index]['recivername']),
                        trailing: IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
