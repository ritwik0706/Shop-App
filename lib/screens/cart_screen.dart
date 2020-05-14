import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/cart.dart';
import '../models/providers/orders.dart';
import '../widgets/list_cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Chip(
                      label: Text(
                        'Rs. ${cart.totalPrice}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                    splashColor: Theme.of(context).accentColor,
                    onPressed: () {
                      if (cart.items.length != 0) {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalPrice);
                        cart.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => ListCartItem(
                productId: cart.items.keys.toList()[i],
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
