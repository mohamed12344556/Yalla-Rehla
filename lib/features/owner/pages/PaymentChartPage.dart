import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'TripChartPage.dart';

class PaymentChartPage extends StatelessWidget {
  const PaymentChartPage({super.key});

  List<FlSpot> getGraphData() {
    return [
      FlSpot(0, 100),
      FlSpot(1, 120),
      FlSpot(2, 110),
      FlSpot(3, 130),
      FlSpot(4, 150),
      FlSpot(5, 170),
      FlSpot(6, 160),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> graphData = getGraphData();
    final minY = graphData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 10;
    final maxY = graphData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Chart (Live Style)"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: Colors.black87,
                      // tooltipRoundedRadius: 8,
                      getTooltipItems: (spots) => spots.map(
                        (e) => LineTooltipItem(
                          "\$${e.y.toStringAsFixed(2)}",
                          const TextStyle(color: Colors.white),
                        ),
                      ).toList(),
                    ),
                    handleBuiltInTouches: true,
                  ),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
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
                        interval: 20,
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
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: graphData,
                      isCurved: true,
                      color: const Color(0xFFAED581),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color:const Color.fromARGB(255, 101, 130, 105),
                      ),
                    ),
                  ],
                  minY: minY,
                  maxY: maxY,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Last Payment: \$${graphData.last.y.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TripChartPage()),
                  );  
                  },
                icon: const Icon(Icons.swap_horiz),
                label: const Text("Swap View"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
