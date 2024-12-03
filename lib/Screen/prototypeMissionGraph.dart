import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MissionProgressGraph extends StatelessWidget {
  final List<int> missionPoints; // List of points from missions for plotting

  const MissionProgressGraph({super.key, required this.missionPoints});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Progress'),
        backgroundColor: Colors.teal[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mission Progress Over Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: missionPoints.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.green, // Custom teal color
// or any other shade like Colors.teal.shade700

                      barWidth: 4,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  minY: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Keep up the great work! Completing more missions will improve your score.',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
