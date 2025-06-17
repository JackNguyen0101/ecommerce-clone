import 'package:ecommerce/common/widgets/loader.dart';
import 'package:ecommerce/features/admin/models/sales.dart';
import 'package:ecommerce/features/admin/services/admin_services.dart';
import 'package:ecommerce/features/admin/widgets/category_products_charts.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  double? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData["sales"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                "\$$totalSales",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                    ),
                    child: SizedBox(
                      width: (earnings!.length * 100).toDouble(),
                      child: CategoryProductsChart(sales: earnings!),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
