import 'package:ecommerce/common/widgets/loader.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/account/services/account_services.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = "/wishlist";
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Product>? products;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchWishListProducts();
  }

  void fetchWishListProducts() async {
    products = await accountServices.fetchWishlistProducts(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: const Text(
          "Your Wishlist",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: products == null
          ? const Loader()
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final productData = products![index];
                final imageUrl = productData.images.isNotEmpty
                    ? productData.images[0]
                    : '';
                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: Text(
                          productData.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
