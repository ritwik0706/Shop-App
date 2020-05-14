import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    double sum = 0.0;
    _items.forEach((key, cartItem) {
      sum += cartItem.price * cartItem.quantity; 
    });
    return sum;
  }

  void additem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          title: value.title,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items  = {};
    notifyListeners();
  }
}
