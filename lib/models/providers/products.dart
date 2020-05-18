import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 799.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 1499.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 999.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 1999.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts([bool filter = false]) async {
    String filterStr = '';
    if(filter == true) {
      filterStr = 'orderBy="createrId"&equalTo="$userId"';
    }
    String url = 'https://shop-app-62b25.firebaseio.com/products.json?auth=$authToken&$filterStr';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
        'https://shop-app-62b25.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favresponse = await http.get(url);
      final favData = json.decode(favresponse.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.add(Product(
          id: key,
          title: value['title'],
          price: value['price'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          isFavourite: favData == null ? false : favData[key] == null ? false : favData[key],
        ));
      });

      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prodItem) async {
    final url = 'https://shop-app-62b25.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': prodItem.title,
          'price': prodItem.price,
          'description': prodItem.description,
          'imageUrl': prodItem.imageUrl,
          'createrId': userId,
        }),
      );

      final newProduct = Product(
          id: json.decode(res.body)['name'],
          description: prodItem.description,
          imageUrl: prodItem.imageUrl,
          price: prodItem.price,
          title: prodItem.title);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url = 'https://shop-app-62b25.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[index] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-app-62b25.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((e) => e.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Error Deleting Product.');
    }
    existingProduct = null;
  }
}
