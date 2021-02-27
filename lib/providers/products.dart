// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:e_avenue_books/providers/product.dart';
// import 'package:e_avenue_books/models/http_exception.dart';

// class Products with ChangeNotifier {
//   final productRef = Firestore.instance.collection('products');
//   final FirebaseUser _firebaseUser;
//   Products(this._firebaseUser, this._items);
//   List<Product> _items = [];
//   List<Product> get items {
//     return [..._items];
//   }

//   String tokenId;
//   var uid;
//   Future<void> getUser() async {
//     var user = await FirebaseAuth.instance.currentUser();
//     var token = await user.getIdToken();
//     tokenId = token.token.toString();
//     print(token.token.toString());
//     if (user == null) {
//       print('Null');
//     } else {
//       uid = user.uid;
//       print(uid);
//     }
//   }
//   // Future getuid(String intuid) {
//   //   if (intuid != null) {
//   //     uid = intuid;
//   //   }
//   // }

//   List<Product> get favoriteItems {
//     return _items.where((prodItem) => prodItem.isFavorite).toList();
//   }

//   Product findById(String id) {
//     return _items.firstWhere((prod) => prod.id == id);
//   }

//   Future<void> fetchAndSetProducts() async {
//     final url = 'https://eavenue-3c455.firebaseio.com/products.json?';
//     try {
//       final doc = await productRef.document().get();
//       // final response = await http.get(url);
//       // final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       // if (extractedData == null) {
//       //   return;
//       // }
//       // final List<Product> loadedProducts = [];
//       // extractedData.forEach((prodId, prodData) {
//       //   loadedProducts.add(Product(
//       //       id: prodId,
//       //       title: prodData['title'],
//       //       description: prodData['description'],
//       //       price: prodData['price'],
//       //       isFavorite: prodData['isFavorite'],
//       //       imageUrl: prodData['imageUrl'],
//       //       userid: prodData['uid']));
//       // });
//       // _items = loadedProducts;
//       notifyListeners();
//     } catch (error) {
//       throw (error);
//     }
//   }

//   Future<void> updateProduct(String id, Product newProduct) async {
//     final prodIndex = _items.indexWhere((prod) => prod.id == id);
//     if (prodIndex >= 0) {
//       final url = 'https://eavenue-3c455.firebaseio.com/products/$id.json';
//       await http.patch(url,
//           body: json.encode({
//             'uid': newProduct.userid,
//             'title': newProduct.title,
//             'description': newProduct.description,
//             'imageUrl': newProduct.imageUrl,
//             'price': newProduct.price
//           }));
//       _items[prodIndex] = newProduct;
//       notifyListeners();
//     } else {
//       print('...');
//     }
//   }

//   Future<void> deleteProduct(String id) async {
//     final url = 'https://eavenue-3c455.firebaseio.com/products/$id.json';
//     final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
//     var existingProduct = _items[existingProductIndex];
//     _items.removeAt(existingProductIndex);
//     StorageReference firebaseStoragereferance =
//         FirebaseStorage.instance.ref().child('${existingProduct.imageUrl}.jpg');
//     final task = firebaseStoragereferance.delete();
//     notifyListeners();
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       _items.insert(existingProductIndex, existingProduct);
//       notifyListeners();
//       throw HttpException('Could not delete product.');
//     }
//     existingProduct = null;
//   }
// }
