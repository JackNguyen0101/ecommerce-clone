import "package:fl_chart/fl_chart.dart";
import 'package:flutter/material.dart';
import 'package:ecommerce/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> sales;
  const CategoryProductsChart({
    Key? key,
    required this.sales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find the max earnings value
    final double maxEarning = sales
        .map((s) => s.earnings)
        .fold(0, (prev, e) => e > prev ? e : prev);

    // Use if-else statements for scaleStep
    double scaleStep;
    if (maxEarning > 10000) {
      scaleStep = 2000;
    } else if (maxEarning > 5000) {
      scaleStep = 1000;
    } else if (maxEarning > 1000) {
      scaleStep = 500;
    } else if (maxEarning > 500) {
      scaleStep = 200;
    } else if (maxEarning > 200) {
      scaleStep = 100;
    } else if (maxEarning > 100) {
      scaleStep = 50;
    } else {
      scaleStep = 10;
    }

    double maxY = ((maxEarning / scaleStep).ceil()) * scaleStep;
    if (maxY == 0) maxY = scaleStep; // Prevent 0 maxY

    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
      ), // Add top padding to prevent cutoff
      child: SizedBox(
        height: 300, // or whatever height you want
        child: BarChart(
          BarChartData(
            maxY: maxY,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            barGroups: sales.asMap().entries.map((entry) {
              int idx = entry.key;
              Sales sale = entry.value;
              return BarChartGroupData(
                x: idx,
                barRods: [
                  BarChartRodData(
                    toY: sale.earnings,
                    color: Colors.blue,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: scaleStep,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 24, // Reserve space at the top
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= sales.length) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        sales[idx].label,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: scaleStep, // Match your Y-axis interval
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
                dashArray: [5, 5], // Optional: dashed lines
              ),
            ),
          ),
        ),
      ),
    );
  }
}
