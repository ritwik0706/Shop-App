import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  void _updateFav() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final url = 'https://shop-app-62b25.firebaseio.com/products/$id.json';
    _updateFav();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      );

      if (response.statusCode >= 400) {
        _updateFav();
        throw HttpException('Error Deleting Product');
      }
    } catch (error) {
      _updateFav();
      throw error;
    }
  }
}
