import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/cart.dart';

class ListCartItem extends StatelessWidget {
  final double price;
  final String title;
  final int quantity;
  final String id;
  final String productId;

  ListCartItem({
    @required this.productId,
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    print('build() called');
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: FittedBox(
                child: Text(
                  'Rs. $price',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('x$quantity'),
            trailing: Text('${price * quantity}'),
          ),
        ),
      ),
    );
  }
}
