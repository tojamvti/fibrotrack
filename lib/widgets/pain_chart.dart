import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/pain_entry.dart';

class PainChart extends StatelessWidget {
  final List<PainEntry> entries;

  const PainChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Text('Brak danych do wyświetlenia.');
    }

    // Sortowanie wpisów po dacie
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < sorted.length) {
                    final date = sorted[index].date;
                    return Text('${date.day}.${date.month}');
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, _) => Text('${value.toInt()}'),
              ),
            ),
          ),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                sorted.length,
                (index) => FlSpot(index.toDouble(), sorted[index].intensity.toDouble()),
              ),
              color: Colors.teal,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
