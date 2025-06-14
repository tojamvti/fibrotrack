import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/pain_entry.dart';

class PainByWeekdayChart extends StatelessWidget {
  final List<PainEntry> entries;

  const PainByWeekdayChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Text('Brak danych.');
    }

    final painSum = List<double>.filled(7, 0);
    final painCount = List<int>.filled(7, 0);

    for (var entry in entries) {
      final weekday = entry.date.weekday % 7; // 0 = niedziela, 1 = pon, ...
      painSum[weekday] += entry.intensity.toDouble();
      painCount[weekday]++;
    }

    final averagePain = List<double>.generate(7, (i) {
      return painCount[i] > 0 ? painSum[i] / painCount[i] : 0;
    });

    const dayLabels = ['Nd', 'Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb'];

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: 10,
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: averagePain[i],
                  width: 14,
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(dayLabels[value.toInt()]),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
