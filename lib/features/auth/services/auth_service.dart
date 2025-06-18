import 'dart:convert';
import 'package:ecommerce/common/widgets/bottom_bar.dart';
import 'package:ecommerce/constants/error_handling.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
        wishlist: [],
        notifications: [],
      );
      http.Response res = await http.post(
        Uri.parse("$uri/api/signup"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-type": "application/json; charset=UTF-8",
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Sign In
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-type": "application/json; charset=UTF-8",
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Get user data
  void getUserData({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        await prefs.setString("x-auth-token", "");
        return;
      }

      final tokenRes = await http.post(
        Uri.parse("$uri/tokenIsValid"),
        headers: <String, String>{
          "Content-type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      // Check for empty response and status code
      if (tokenRes.statusCode == 200 && tokenRes.body.isNotEmpty) {
        final isValid = jsonDecode(tokenRes.body) == true;
        if (isValid) {
          final userRes = await http.get(
            Uri.parse("$uri/"),
            headers: <String, String>{
              "Content-type": "application/json; charset=UTF-8",
              "x-auth-token": token,
            },
          );
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUser(userRes.body);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
