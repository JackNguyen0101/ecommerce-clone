import 'dart:convert';

import 'package:ecommerce/constants/error_handling.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/features/auth/screens/auth_screen.dart';
import 'package:ecommerce/models/notification.dart';
import 'package:ecommerce/models/order.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/orders/me"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List products = jsonDecode(res.body);
          orderList = products.map((e) => Order.fromMap(e)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/products"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List products = jsonDecode(res.body);
          productList = products.map((e) => Product.fromMap(e)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<List<Product>> fetchWishlistProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/wishlist"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List products = jsonDecode(res.body);
          productList = products.map((e) => Product.fromMap(e)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<List<AppNotification>> fetchNotifications(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<AppNotification> notifications = [];
    try {
      final res = await http.get(
        Uri.parse("$uri/api/notifications"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List notifList = jsonDecode(res.body);
          notifications = notifList
              .map((e) => AppNotification.fromMap(e))
              .toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return notifications;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setUser('{}');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteNotification({
    required BuildContext context,
    required String notifId,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/notifications/$notifId'),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
