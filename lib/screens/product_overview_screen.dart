import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/cart.dart';
import '../models/providers/products.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/main_app_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavs = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<Products>(context, listen: false).fetchProducts();
    _isLoading = true;
    Future.delayed(Duration.zero)
        .then((value) =>
            Provider.of<Products>(context, listen: false).fetchProducts())
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // var isInit = true;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if(isInit) {
  //     Provider.of<Products>(context, listen: false).fetchProducts();
  //   }
  //   isInit = false;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (ctx, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
            PopupMenuButton(
              onSelected: (val) {
                setState(() {
                  if (val == FilterOptions.Favourites)
                    _showOnlyFavs = true;
                  else
                    _showOnlyFavs = false;
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Show Favourites'),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
          ],
        ),
        drawer: MainAppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showOnlyFavs),
      ),
    );
  }
}
