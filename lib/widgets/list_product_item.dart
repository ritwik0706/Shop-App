import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../screens/edit_product_screen.dart';
import '../models/providers/products.dart';

class ListProductItem extends StatelessWidget {
  final String id;
  final String url;
  final String title;
  ListProductItem(this.id, this.title, this.url);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: id),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      ),
      title: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: id),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting Failed!', textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
