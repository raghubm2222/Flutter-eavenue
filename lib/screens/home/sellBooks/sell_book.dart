import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_avenue_books/Constants.dart';
import 'package:e_avenue_books/models/login_store.dart';
import 'package:e_avenue_books/models/message.dart';
import 'package:e_avenue_books/providers/product.dart';
import 'package:e_avenue_books/screens/appdrawer/app_drawer.dart';
import 'package:e_avenue_books/screens/chat/chats_lists.dart';
import 'package:e_avenue_books/screens/home/sellBooks/searchedproducts.dart';
import 'package:e_avenue_books/screens/products/product_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'new_product_detail_screen.dart';

class SellBookScreen extends StatefulWidget {
  static const routeName = '/sellbookscreen';
  final String branch;
  

  const SellBookScreen({
    Key key,
    @required this.branch,
  }) : super(key: key);
  @override
  _SellBookScreenState createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  TextEditingController textEditingController = TextEditingController();
  String branchname;
  String sorttext = 'uploadedOn';
  bool desending = true;
  bool issearching = false;
  bool isloading = false;
  final _debouncer = Debouncer(milliseconds: 500);
  List<Product> _items = [];
  List<Product> filteresProducts = List();
  void filter(int number) {
    setState(() {
      branchname = branchesList[number];
    });
  }

  void sortby(int number) {
    if (number == 2) {
      setState(() {
        sorttext = 'price';
        desending = true;
      });
    } else if (number == 3) {
      setState(() {
        sorttext = 'price';
        desending = false;
      });
    } else if (number == 1) {
      setState(() {
        sorttext = 'uploadedOn';
        desending = true;
      });
    }
  }

  Future<void> getproducts() async {
    setState(() {
      isloading = true;
    });
    final List<Product> loadedProducts = [];
    final dta = issearching
        ? await Firestore.instance.collection('products').getDocuments()
        : await Firestore.instance
            .collection('products')
            .where('branch', isEqualTo: branchname)
            .orderBy(sorttext, descending: desending)
            .getDocuments();
    final doc = dta.documents;
    doc.forEach((prodData) {
      loadedProducts.add(
        Product(
          author: prodData['author'],
          price: prodData['price'].toString(),
          profilePic: prodData['profilepic'],
          uid: prodData['uid'],
          name: prodData['name'],
          branch: prodData['branch'],
          course: prodData['course'],
          uploadedon: prodData['uploadedOn'].toString(),
          imageurl: prodData['imageUrl'],
          description: prodData['description'],
          title: prodData['title'],
          productID: prodData.documentID,
        ),
      );
    });
    _items = loadedProducts;
    filteresProducts = _items;
    setState(() {
      isloading = false;
    });
  }

  showbottomsheet(bool isFilter) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isFilter
                      ? branchesList.map((branch) {
                          return FlatButton(
                            onPressed: () {
                              filter(branchesList.indexOf(branch));
                              getproducts();
                              Navigator.pop(context);
                            },
                            child: Text(
                              branch,
                            ),
                          );
                        }).toList()
                      : sortlist.map((sor) {
                          return FlatButton(
                            onPressed: () {
                              sortby(sortlist.indexOf(sor));
                              getproducts();
                              Navigator.pop(context);
                            },
                            child: Text(
                              sor,
                            ),
                          );
                        }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      branchname = widget.branch;
    });
    getproducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          drawer: AppDrawer(),
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 120),
            child: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              title: Text('EAvenue'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Messages()));
                    }),
              ],
              bottom: PreferredSize(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            onChanged: (string) {
                              _debouncer.run(() {
                                setState(() {
                                  filteresProducts = _items
                                      .where((u) => (u.branch
                                              .toLowerCase()
                                              .contains(string.toLowerCase()) ||
                                          u.title
                                              .toLowerCase()
                                              .contains(string.toLowerCase()) ||
                                          u.course
                                              .toLowerCase()
                                              .contains(string.toLowerCase())))
                                      .toList();
                                });
                              });
                            },
                            onTap: () {
                              filteresProducts.clear();
                              setState(() {
                                issearching = !issearching;
                              });
                              getproducts();
                            },
                            decoration: searchDecoration,
                          ),
                        ),
                        if (issearching) ...[
                          ClearContainer(
                            onTap: () {
                              textEditingController.clear();
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              filteresProducts = _items;
                              setState(() {
                                issearching = false;
                              });
                              getproducts();
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 30.0)),
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: FilterSortBtn(
                  iconData: Icons.filter_list,
                  title: 'Filter',
                  ontap: () => showbottomsheet(true),
                ),
              ),
              Expanded(
                child: FilterSortBtn(
                  iconData: Icons.swap_vert,
                  title: 'Sort',
                  ontap: () => showbottomsheet(false),
                ),
              ),
            ],
          ),
          body: isloading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteresProducts.length,
                  itemBuilder: (context, index) {
                    return ProductsTile(
                      product: filteresProducts[index],
                      firebaseUser: loginStore.firebaseUser,
                    );
                  },
                ),
        );
      },
    );
  }
}
