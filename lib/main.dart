import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './models/providers/products.dart';
import './models/providers/cart.dart';
import './models/providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromRGBO(91, 117, 130, 1),
          accentColor: Color.fromRGBO(249, 189, 8, 1),
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routename: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
