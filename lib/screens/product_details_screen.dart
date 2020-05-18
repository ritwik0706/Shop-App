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
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            elevation: 20,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20  ,
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                SizedBox(
                  height: 480,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
