import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecommerce/constants/error_handling.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/features/admin/models/sales.dart';
import 'package:ecommerce/models/order.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("dwnvkcrga", "c8xcy4ka");
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse("$uri/admin/add-product"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Product Added Successfully!");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/admin/get-products"),
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
          orderList = products.map((e) => Product.fromMap(e)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  // delete product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/admin/delete-product"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode(
          {
            "id": product.id,
          },
        ),
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

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/admin/get-orders"),
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

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/admin/change-order-status"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode(
          {
            "id": order.id,
            "status": status,
          },
        ),
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

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    double totalEarnings = 0;
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/admin/analytics"),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          sales = [
            Sales("Mobiles", (response["mobileEarnings"] ?? 0).toDouble()),
            Sales(
              "Essentials",
              (response["essentialEarnings"] ?? 0).toDouble(),
            ),
            Sales(
              "Appliances",
              (response["applianceEarnings"] ?? 0).toDouble(),
            ),
            Sales("Books", (response["bookEarnings"] ?? 0).toDouble()),
            Sales("Fashion", (response["fashionEarnings"] ?? 0).toDouble()),
            Sales("Food", (response["foodEarnings"] ?? 0).toDouble()),
          ];
          totalEarnings = (response["totalEarnings"] ?? 0).toDouble();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {"sales": sales, "totalEarnings": totalEarnings};
  }
}
