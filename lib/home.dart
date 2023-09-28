
import 'package:aplikasikas_vero/DatabaseHelper.dart';
import 'package:aplikasikas_vero/Login.dart';
import 'package:aplikasikas_vero/pengaturan.dart';
import 'package:aplikasikas_vero/tambahKeluar.dart';
import 'package:aplikasikas_vero/tambahMasuk.dart';
import 'package:aplikasikas_vero/tampilKas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeApp extends StatefulWidget {
  @override
  _homeAppState createState() => _homeAppState();
}
final dbHelper = DatabaseHelper();
  double totalPlus = 0.0;

class _homeAppState extends State<HomeApp> {
    final dbHelper = DatabaseHelper();
  double totalPlus = 0.0;
  double totalMin = 0.0;



  Future<void> _calculateTotalPlus() async {
    final total = await dbHelper.getTotalPlus();
    setState(() {
      totalPlus = total;
    });
  }

  Future<void> _calculateTotalMin() async {
    final total = await dbHelper.getTotalMin();
    setState(() {
      totalMin = total;
    });
  }

  Future<void> _refreshdata() async {
    final total = await dbHelper.getTotalPlus();
    final total1 = await dbHelper.getTotalMin();
    setState(() {
      totalPlus = total;
      totalMin = total1;
    });
  }

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    runApp(username != null && password != null ? HomeApp() : LoginApp());
  }

  @override
  void initState() {
     _calculateTotalPlus();
     _calculateTotalMin();
    super.initState();
   // Menangkap sinyal pembaruan data dari layar sebelumnya
  Future.delayed(Duration.zero, () {
    final shouldRefresh = ModalRoute.of(context)?.settings.arguments;
    if (shouldRefresh == true) {
      _refreshdata();
    }
  });
} 
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /*
        appBar: AppBar(
          title: const Text('Login Page'),
          backgroundColor:
              Colors.blueGrey, // Ganti dengan warna yang Anda sukai
        ),*/
        body:
         SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
// Set ini agar text di dalam kolom kiri rata kiri
                children: <Widget>[
                  // Kolom pertama dengan dua baris teks
                  Column(
                    children: <Widget>[
                          const SizedBox(height: 50,),
                          const Text('Rangkuman Bulan ini'),
                          Text(
                          'Total Pemasukkan: ${totalPlus.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      Text('Total Pengurangan: ${totalMin.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                    ],
                  ),

                 const SizedBox(height: 16,),
                 
                 Row(
                children: <Widget>[
                  // Kolom 1 dalam Row
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tambahMasuk(),
                              settings: const RouteSettings(
                                  arguments:
                                      true)), // Menggantikan layar saat ini dengan HomeApp
                        );
                      },
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage("assets/login2.png"),
                            height: 200,
                            width: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                // Spacer antara kolom dalam Row
                  // Kolom 2 dalam Row
                  Expanded(


                     child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tambahKeluar()));
                      },
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage("assets/login3.png"),
                            height: 200,
                            width: 200,
                          ),
                        ],
                      ),
                    ),

                  ),

                ],
              ),

                  Row(
                    children: <Widget>[
                      // Kolom 1 dalam Row
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  tampilKas()));
                          },
                          child: const Column(
                            children: [
                              Image(
                                image: AssetImage("assets/login5.png"),
                                height: 200,
                                width: 200,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Spacer antara kolom dalam Row
                      // Kolom 2 dalam Row
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  pengaturan()));
                          },
                          child: const Column(
                            children: [
                              Image(
                                image: AssetImage("assets/login4.png"),
                                height: 200,
                                width: 200,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  



         
 
                ]
  )
  )
      )
  );
    
 
  }
}

