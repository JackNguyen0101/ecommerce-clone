import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/account/screens/notification_screen.dart';
import 'package:ecommerce/features/account/widgets/below_app_bar.dart';
import 'package:ecommerce/features/account/widgets/orders.dart';
import 'package:ecommerce/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void navigateToNotificationScreen(BuildContext context) {
    Navigator.pushNamed(context, NotificationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/amazon_in.png",
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () => navigateToNotificationScreen(context),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20),
          Orders(),
        ],
      ),
    );
  }
}
