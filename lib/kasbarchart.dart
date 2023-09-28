import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'KasModel.dart'; // Pastikan Anda mengimpor model dengan benar


class KasBarChart extends StatelessWidget {
  final Future<List<KasModel>> kasDataListFuture; // Gunakan Future

  KasBarChart(this.kasDataListFuture) {
    // Panggil constructor dengan Future
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KasModel>>(
      future: kasDataListFuture, // Gunakan future di sini
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan widget loading jika data masih dimuat
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Tampilkan pesan kesalahan jika terjadi kesalahan
          return Text('Error: ${snapshot.error}');
        } else {
          // Ambil data dari snapshot
          final kasDataList = snapshot.data;

          // Tampilkan grafik jika data sudah tersedia
          return BarChart(
            BarChartData(
              barGroups: kasDataList?.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index.toDouble().toInt(),
                  barRods: [
                    BarChartRodData(
                      y: data.nominal,
                      colors: [data.nominal < 0 ? Colors.red : Colors.blue],
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: true),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (double value) {
                    final int index = value.toInt();
                    if (index >= 0 && index < kasDataList!.length) {
                      return kasDataList[index].tanggal.toString();
                    }
                    return '';
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
