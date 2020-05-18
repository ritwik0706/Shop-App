import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/manage_products_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../models/providers/auth.dart';

class MainAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Shop App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Shop'),
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Cart'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //       color: Theme.of(context).accentColor),
            //   child: ListTile(
            //     leading: Icon(Icons.favorite),
            //     title: Text('Favourites'),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: ListTile(
                leading: Icon(Icons.payment),
                title: Text('Orders'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(OrdersScreen.routename);
                  // Navigator.of(context).pushReplacement(
                  //   CustomRoute(
                  //     builder: (ctx) => OrdersScreen(),
                  //   ),
                  // );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Manage Products'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(ManageProductsScreen.routeName);
                  }),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logOut();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
