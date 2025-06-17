import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    for (var e in user.cart) {
      final quantity = (e['quantity'] ?? 0) as int;
      final price = (e['product']['price'] ?? 0).toDouble();
      sum += quantity * price;
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            "Subtotal ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            "\$${sum.toStringAsFixed(2)} ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
