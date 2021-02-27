import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'colors.dart';

class ChatScreen extends StatefulWidget {
  final String sellername;
  final String sellerpic;
  final String selleruid;

  const ChatScreen({
    Key key,
    @required this.sellername,
    @required this.sellerpic,
    @required this.selleruid,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  bool isexists = false;
  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
  }

  addtomessagelist(String senderuid, String reciveruid, String sendername,
      String senderpic) async {
    final messagesList = await Firestore.instance
        .collection('users')
        .document(senderuid)
        .collection('messageslist')
        .document(reciveruid)
        .get();
    if (!messagesList.exists) {
      Firestore.instance
          .collection('users')
          .document(senderuid)
          .collection('messageslist')
          .document(reciveruid)
          .setData({
        'reciveruid': widget.selleruid,
        'recivername': widget.sellername,
        'reciverpic': widget.sellerpic
      }).then((_) {
        Firestore.instance
            .collection('users')
            .document(reciveruid)
            .collection('messageslist')
            .document(senderuid)
            .setData({
          'reciveruid': senderuid,
          'recivername': sendername,
          'reciverpic': senderpic
        }).then((value) {
          setState(() {
            isexists = true;
          });
        });
      });
    } else {
      setState(() {
        isexists = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  sendmessage(String senderuid, reciveruid) async {
    String message = textFieldController.text;

    textFieldController.clear();
    final userRef = Firestore.instance.collection('messages');
    final sender = userRef.document(senderuid).collection(reciveruid);
    final reciver = userRef.document(reciveruid).collection(senderuid);
    var messagedata = {
      'message': message,
      'senderID': senderuid,
      'reciverID': reciveruid,
      'timestamp': Timestamp.now()
    };
    sender.add(messagedata);
    reciver.add(messagedata);
  }

  Radius messageRadius = Radius.circular(10);
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginstore, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: NetworkImage(widget.sellerpic),
                ),
              ),
              elevation: 0,
              title: Text(widget.sellername,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 18))),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('messages')
                        .document(loginstore.firebaseUser.uid)
                        .collection(widget.selleruid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      } 
                      final doc = snapshot.data.documents;
                      return ListView.builder(
                        reverse: true,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          if (doc.length == 0) {
                            return Center(
                              child: Text('Loading.....'),
                            );
                          }
                          return Container(
                            child: Container(
                              alignment: doc[index]['senderID'] ==
                                      loginstore.firebaseUser.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: doc[index]['senderID'] ==
                                      loginstore.firebaseUser.uid
                                  ? SenderBubble(
                                      message: doc[index]['message'],
                                    )
                                  : ReciverBubble(
                                      message: doc[index]['message'],
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 5.0,
                              spreadRadius: 5.0,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: textFieldController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (val) {
                            (val.length > 0 && val.trim() != "")
                                ? setWritingTo(true)
                                : setWritingTo(false);
                          },
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            //filled: true,
                            //fillColor: UniversalVariables.separatorColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff00b6f3), Color(0xff0184dc)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isWriting ? Icons.send : Icons.photo_library,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          sendmessage(
                            loginstore.firebaseUser.uid,
                            widget.selleruid,
                          );
                          if (!isexists) {
                            addtomessagelist(
                              loginstore.firebaseUser.uid,
                              widget.selleruid,
                              loginstore.documentSnapshot['name'],
                              loginstore.documentSnapshot['imageUrl'],
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReciverBubble extends StatelessWidget {
  final String message;
  const ReciverBubble({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 5),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          topLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class SenderBubble extends StatelessWidget {
  final String message;
  const SenderBubble({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 5),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
