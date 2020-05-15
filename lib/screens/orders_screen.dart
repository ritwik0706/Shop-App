import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/list_order_item.dart';

import '../models/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => ListOrderItem(
                      orderData.orders[i],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Error while fetching orders...'),
              );
            }
          }
        },
      ),
    );
  }
}
