import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future<File> generatePainStatsPdf({
  required DateTime startDate,
  required DateTime endDate,
  required int entryCount,
  required int highestPain,
  required String averagePain,
  required Map<String, int> locationCount,
  required Map<String, int> characterCount,
}) async {
  final pdf = pw.Document();
  final dateFormat = DateFormat('yyyy-MM-dd');

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('📄 Statystyki bólu', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Text('📅 Zakres dat: ${dateFormat.format(startDate)} – ${dateFormat.format(endDate)}'),
          pw.SizedBox(height: 12),
          pw.Text('📊 Liczba wpisów: $entryCount'),
          pw.Text('🔥 Najwyższa intensywność: $highestPain'),
          pw.Text('📈 Średnia intensywność: $averagePain'),
          pw.SizedBox(height: 16),
          if (locationCount.isNotEmpty) ...[
            pw.Text('📍 Najczęstsze lokalizacje bólu:'),
            ...locationCount.entries.map((e) => pw.Text('${e.key}: ${e.value}×')),
            pw.SizedBox(height: 12),
          ],
          if (characterCount.isNotEmpty) ...[
            pw.Text('🔥 Najczęstszy charakter bólu:'),
            ...characterCount.entries.map((e) => pw.Text('${e.key}: ${e.value}×')),
          ],
        ],
      ),
    ),
  );

  final outputDir = await getTemporaryDirectory();
  final filePath = '${outputDir.path}/pain_stats_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return file;
}
