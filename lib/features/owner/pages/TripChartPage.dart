import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'PaymentChartPage.dart';

class TripChartPage extends StatelessWidget {
  const TripChartPage({super.key});

  List<double> getTripPrices() {
    return [220, 280, 190, 310, 260, 230, 270, 295, 250, 275, 300, 320];
  }

  @override
  Widget build(BuildContext context) {
    final prices = getTripPrices();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final maxY = prices.reduce((a, b) => a > b ? a : b) + 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Price Chart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Average Trip Prices per Month",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          "\$${rod.toY.toStringAsFixed(2)}",
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value >= 0 && value < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                months[value.toInt()],
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        getTitlesWidget: (value, _) => Text(
                          "\$${value.toInt()}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(prices.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: prices[i],
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          color: const Color.fromARGB(255, 101, 130, 105),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: const Color.fromARGB(255, 207, 221, 192).withOpacity(0.2),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {

                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentChartPage()),
                  );                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text("Swap View"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
