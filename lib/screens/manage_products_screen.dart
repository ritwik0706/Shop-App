import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/products.dart';
import '../widgets/list_product_item.dart';
import './edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products-screen';

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshItems(context),
              child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (ctx, i) => ListProductItem(
              productData.items[i].id,
              productData.items[i].title,
              productData.items[i].imageUrl,
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
