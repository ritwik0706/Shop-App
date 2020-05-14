import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/providers/orders.dart';

class ListOrderItem extends StatefulWidget {
  final OrderItem orderItem;
  ListOrderItem(this.orderItem);

  @override
  _ListOrderItemState createState() => _ListOrderItemState();
}

class _ListOrderItemState extends State<ListOrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).accentColor,
              child: ListTile(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                contentPadding: EdgeInsets.all(10),
                title: Text('Rs. ${widget.orderItem.amount.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.orderItem.dateTime)
                    .toString()),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
            ),
            if (_expanded)
              Container(
                height: min(max(100, widget.orderItem.products.length * 20.0), 150),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: ListView(
                  children: widget.orderItem.products
                      .map(
                        (product) => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        product.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                          '${product.quantity}x${product.price}'),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 10,
                                  ),
                                  child:
                                      Text('Rs.${product.quantity * product.price}'),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
