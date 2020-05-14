import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Chip(
            backgroundColor: Theme.of(context).accentColor,
            label: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    loadedProduct.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Price : Rs. ${loadedProduct.price}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text(loadedProduct.description),
        ],
      ),
    );
  }
}
