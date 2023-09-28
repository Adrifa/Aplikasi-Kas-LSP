import 'package:aplikasikas_vero/Login.dart';
import 'package:aplikasikas_vero/home.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
 // Import KasModel
import 'DatabaseHelper.dart'; // Import DatabaseHelper

class pengaturan extends StatefulWidget {
  @override
  _pengaturanState createState() => _pengaturanState();
}

class _pengaturanState extends State<pengaturan> {
  final dbHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordlama = TextEditingController();
  final TextEditingController _passwordbaru = TextEditingController();
  final status1 = 'plus';
  String sesNama = "";
  String sesPassword = "";

   getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        sesNama = pref.getString("username")!;
        sesPassword = pref.getString("password")!;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginApp(),
        ),
        (route) => false,
      );
    }
  } 

  @override
  void initState() {
    getPref();
    //load session
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
               TextFormField(
                controller: _passwordlama,
                decoration: const InputDecoration(labelText: 'Password Saat ini ' ),
                validator: (val) {
                  return null;
                },
              ),

              TextFormField(
                controller: _passwordbaru,
                decoration: const InputDecoration(labelText: 'Password Baru'),
                validator: (val) {
                  return null;
                },
              ),
              const SizedBox(width: 20.0), //
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                       
                    final passwordlamaText = _passwordlama.text;
                    final passwordbaruText = _passwordbaru.text;

                    
                    if (passwordlamaText == sesPassword) {
                      await dbHelper.updatePassword(sesNama, passwordbaruText);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Data Tersimpan'),
                            content: const Text('Password telah di ganti'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog

                                  // Alihkan pengguna ke halaman home.dart dan refresh data
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeApp()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }

                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Atur padding horizontal sesuai kebutuhan
                  minimumSize: const Size(double.infinity,
                      48.0), // Menetapkan tinggi tombol (48.0) dan lebar maksimum
                ),                
                child: const Text('Simpan'),
              ),
              SizedBox(height: 20),
              Center(
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        // Gambar di sebelah kiri
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/login1.png'), // Ganti dengan gambar Anda
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0), // Jarak antara gambar dan teks
                        // Informasi identitas diri di sebelah kanan
                       const  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'NIM: 2141764104',
                              style: TextStyle(fontSize: 16.0),
                            ),                            
                            Text(
                              'Nama: Adrifa Ammar \n Savero',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Umur: 22 tahun',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Alamat: Perum Bumi \n mas 1  Blok z \n No. 15 Madiun ',
                              style: TextStyle(fontSize: 16.0),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
          ),
          
         
        ),
        
      ),
    
    );
  }


}
