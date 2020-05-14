import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/list_order_item.dart';

import '../models/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => ListOrderItem(
          orderData.orders[i],
        ),
      ),
    );
  }
}
