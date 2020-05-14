import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/grid_product_item.dart';
import '../models/providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final showFav;
  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productList = showFav ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productList[index],
        child: GridProductItem(
          // productList[index].id,
          // productList[index].title,
          // productList[index].imageUrl,
        ),
      ),
      itemCount: productList.length,
    );
  }
}
