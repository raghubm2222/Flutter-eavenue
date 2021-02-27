import 'providers/cart.dart';
import 'providers/orders.dart';
import 'models/login_store.dart';
import 'screens/auth/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          builder: (_) => LoginStore(),
        ),
        // ChangeNotifierProxyProvider<LoginStore, Products>(
        //   builder: (ctx, auth, previoudProducts) => Products(auth.firebaseUser,
        //       previoudProducts == null ? [] : previoudProducts.items),
        // ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // accentColor: Colors.green,
          fontFamily: 'Lato',
        ),
        home: SplashPage(),
      ),
    );
  }
}
