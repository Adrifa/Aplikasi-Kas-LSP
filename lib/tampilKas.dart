
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'KasModel.dart'; // Import KasModel
import 'DatabaseHelper.dart'; // Import DatabaseHelper

class tampilKas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KasScreen(),
    );
  }
}

class KasScreen extends StatefulWidget {
  @override
  _KasScreenState createState() => _KasScreenState();
}

class _KasScreenState extends State<KasScreen> {
  final dbHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _statusController =
      TextEditingController(); // Tambahkan controller untuk status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Kas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Tanggal, nominal, dan keterangan tetap sama seperti sebelumnya
              // ...

              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Detail Cash Flow'),
              ),


              Expanded(
                child: FutureBuilder<List<KasModel>>(
                  future: dbHelper.getKasList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final kasList = snapshot.data;

                    return ListView.builder(
                      itemCount: kasList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final kas = kasList![index];
                        return ListTile(
                          //title: Text('Tanggal: ${DateFormat('yyyy-MM-dd').format(kas.tanggal)}'),
                          title:
                              Text('${kas.status == 'plus' ? '[ + ]' : '[ - ]'} Rp: ${kas.nominal.toStringAsFixed(2)}'),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Keterangan: ${kas.keterangan}'), // Tampilkan status
                              Text( 'Tanggal: ${DateFormat('yyyy-MM-dd').format(kas.tanggal)}'), // Tampilkan status
                            ],
                          ),
                          trailing: IconButton(
                              icon: kas.status == 'plus'
                                  ? const Icon(Icons.arrow_forward,color: Colors.green)
                                  : const Icon(Icons.arrow_back, color: Colors.red),
                              onPressed: () {
                                                           /*
                            onPressed: () async {
                              await dbHelper.deleteKas(kas.id!);
                              setState(() {});
                            },
                            */
                              },
                            )
 

                          
                        );
                      },
                    );                 
                  },
                ),
              ),            
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  void _resetForm() {
    _formKey.currentState?.reset();
    _tanggalController.clear();
    _nominalController.clear();
    _keteranganController.clear();
    _statusController.clear();
  }
}
