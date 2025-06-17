import 'package:ecommerce/common/screens/speech_screen.dart';
import 'package:ecommerce/common/widgets/bottom_bar.dart';
import 'package:ecommerce/features/account/screens/wishlist_screen.dart';
import 'package:ecommerce/features/address/screens/address_screen.dart';
import 'package:ecommerce/features/admin/screens/add_products_screen.dart';
import 'package:ecommerce/features/auth/screens/auth_screen.dart';
import 'package:ecommerce/features/home/screens/category_deals_screen.dart';
import 'package:ecommerce/features/home/screens/home_screen.dart';
import 'package:ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:ecommerce/features/search/screens/search_screen.dart';
import 'package:ecommerce/models/order.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddProductsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductsScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailsScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailsScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmountPay = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmountPay: totalAmountPay,
        ),
      );
    case OrderDetailsScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailsScreen(
          order: order,
        ),
      );
    case SpeechScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SpeechScreen(),
      );
    case WishlistScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => WishlistScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
      );
  }
}
