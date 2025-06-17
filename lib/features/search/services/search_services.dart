import 'dart:convert';

import 'package:ecommerce/constants/error_handling.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/products/search/$searchQuery"),
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
}
