import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../models/providers/product.dart';
import '../models/providers/cart.dart';
import '../models/providers/auth.dart';

class GridProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routeName,
                  arguments: product.id,
                ),
            child: Hero(
              tag: product.id,
                          child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.jpg'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                try {
                  await product.toggleFavouriteStatus(
                      authData.token, authData.userId);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add to fvourites.')),
                  );
                }
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.additem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
