import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_product_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/auth_screen.dart';
import './models/providers/products.dart';
import './models/providers/cart.dart';
import './models/providers/orders.dart';
import './models/providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, []),
          update: (ctx, auth, previousProducts) => Products(auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        // ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromRGBO(91, 117, 130, 1),
            accentColor: Color.fromRGBO(249, 189, 8, 1),
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routename: (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
