import 'package:ecommerce/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: "",
    name: "",
    email: "",
    password: "",
    address: "",
    type: "",
    token: "",
    cart: [],
    wishlist: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void addToWishlist(String productId) {
    if (!_user.wishlist.contains(productId)) {
      _user.wishlist.add(productId);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _user.wishlist.remove(productId);
    notifyListeners();
  }

  void setWishlist(List<dynamic> wishlist) {
    _user.wishlist
      ..clear()
      ..addAll(wishlist);
    notifyListeners();
  }
}
