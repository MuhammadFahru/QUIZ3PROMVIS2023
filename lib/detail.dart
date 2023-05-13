import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPinjaman {
  String id;
  String nama;
  String bunga;
  String isSyariah;
  DetailPinjaman({required this.id, required this.nama, required this.bunga, required this.isSyariah});
}

class APIPinjaman {
  

  String id = "5";
  String nama = "Pinjaman jenis 3 varian A";
  String bunga = "3.5%";
  String isSyariah = "TIDAK";
  APIPinjaman();

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    bunga = json['bunga'];
    isSyariah = json['is_syariah'];
  }

  String get getId => id;
  String get getNama => nama;
  String get getBunga => bunga;
  String get getIsSyariah => isSyariah;

  void fetchData(String id) async {
    String url = "http://178.128.17.76:8000/detil_jenis_pinjaman/$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class Detail extends StatelessWidget {
  final String id;

  final APIPinjaman data = APIPinjaman();

  Detail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    data.fetchData(id);
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            )),
            const SizedBox(height: 16.0),
            Center(
                child: Text(
              'ID : ${data.getId}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            )),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Nama:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(data.getNama,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Bunga:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              data.getBunga,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Syariah:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              data.getIsSyariah,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Center(
                child: ElevatedButton(
              child: const Text("Kembali"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ))
          ],
        ),
      ),
    );
  }
}
