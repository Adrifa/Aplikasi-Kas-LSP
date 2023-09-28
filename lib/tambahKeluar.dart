import 'package:aplikasikas_vero/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'KasModel.dart'; // Import KasModel
import 'DatabaseHelper.dart'; // Import DatabaseHelper

class tambahKeluar extends StatefulWidget {
  @override
  _tambahKeluarState createState() => _tambahKeluarState();
}

class _tambahKeluarState extends State<tambahKeluar> {
  final dbHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DateTimeField(
                format: DateFormat("yyyy-MM-dd"),
                controller: _tanggalController,
                decoration:
                    const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                },
                validator: (val) {
                  if (val == null) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    //_tanggalController.text = DateFormat("yyyy-MM-dd").format(val);
                  });
                },
              ),
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  return null;
                },
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                validator: (val) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _resetForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            16.0), // Atur padding horizontal sesuai kebutuhan
                    minimumSize: const Size(double.infinity,
                        48.0), // Menetapkan tinggi tombol (48.0) dan lebar maksimum
                  ),                   
                  child: const Text("Reset")),   
              const SizedBox(height: 10),          
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    final tanggalText = _tanggalController.text;
                    final nominalText = _nominalController.text;
                    final keteranganText = _keteranganController.text;

                    if (tanggalText.isNotEmpty &&
                        nominalText.isNotEmpty &&
                        keteranganText.isNotEmpty) {
                      final tanggal = DateTime.parse(tanggalText);
                      final nominal = double.parse(nominalText);
                      final keterangan = keteranganText;
                      // ignore: unused_local_variable
                      const status = 'min';

                      final kas = KasModel(
                        tanggal: tanggal,
                        nominal: nominal,
                        keterangan: keterangan,
                        status: status,
                      );
                      await dbHelper.insertKas(kas);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Data Tersimpan'),
                            content: const Text('Data Anda telah berhasil disimpan.'),
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
              const SizedBox(height: 10),   
              ElevatedButton(
                  onPressed: () {
                    // Alihkan pengguna ke halaman home.dart dan refresh data
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeApp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            16.0), // Atur padding horizontal sesuai kebutuhan
                    minimumSize: const Size(double.infinity,
                        48.0), // Menetapkan tinggi tombol (48.0) dan lebar maksimum
                  ),                   
                  child: const Text("Kembali")),

            ],
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    _tanggalController.clear();
    _nominalController.clear();
    _keteranganController.clear();
  }
}
