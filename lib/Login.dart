// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'DatabaseHelper.dart';
import 'home.dart';

class LoginApp extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUser(username, password);
    // Contoh validasi login (misalnya, dengan database)
    if (user!=null) {
      
        // Simpan username dan password di Sh
        // aredPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('password', password);
        await prefs.setBool("is_login", true);
        // Login berhasil, arahkan ke halaman HomeApp
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeApp()),
        );
                  
    } else {
      // Login gagal
      print('Login gagal');
      _showLoginFailedDialog(context);
    }
  }

  Future<void> _showLoginFailedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Username atau password salah. Silakan coba lagi.'),
          actions: <Widget>[
            TextButton(
              child:const  Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Image(
              image: AssetImage("assets/login1.png"),
              height: 200,
              width: 200,
            ),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text("Aplikasi My Cash V.0.1",
                    style: TextStyle(
                      fontSize: 16.0, // Ganti dengan ukuran font yang Anda inginkan
                      // Anda juga dapat menambahkan properti TextStyle lainnya jika diperlukan
                      )),
                ],
            

                  
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const  InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _login,
               style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        14.0), // Atur padding horizontal sesuai kebutuhan
                minimumSize: const Size(double.infinity,
                    48.0), // Menetapkan tinggi tombol (48.0) dan lebar maksimum
              ),             
              child: const Text('Login'),
              
            ),
          ],
        ),
      ),
    );
  }
}



