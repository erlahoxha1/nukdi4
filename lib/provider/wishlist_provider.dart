import 'package:flutter/material.dart';
import 'package:nukdi4/models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  void addToWishlist(Product product) {
    if (!_wishlist.any((item) => item.id == product.id)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _wishlist.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }
}
