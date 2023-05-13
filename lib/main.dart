import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JenisPinjaman {
  String id;
  String nama;
  JenisPinjaman({required this.id, required this.nama});
}

class ListJenisPinjaman {
  List<JenisPinjaman> listJPinjaman = <JenisPinjaman>[];
  ListJenisPinjaman({required this.listJPinjaman});
}

class ListJenisPinjamanModel extends ChangeNotifier {
  String selectedPinjaman = "0";

  List<JenisPinjaman> listJenisPinjamanModel = <JenisPinjaman>[];

  ListJenisPinjamanModel({required this.listJenisPinjamanModel}) {
    fetchData();
  }

  void setSelectedPinjaman(String pinjaman) {
    selectedPinjaman = pinjaman;
    fetchData();
  }

  void setFromJson(Map<String, dynamic> json) {
    listJenisPinjamanModel.clear();
    var data = json["data"];
    for (var val in data) {
      var id = val["id"];
      var nama = val["nama"];
      listJenisPinjamanModel.add(JenisPinjaman(id: id, nama: nama));
      notifyListeners();
    }
  }

  void fetchData() async {
    String url = "http://178.128.17.76:8000/jenis_pinjaman/$selectedPinjaman";
    // "http://universities.hipolabs.com/search?country=$selectedPinjaman";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class JenisPinjamanCubit extends Cubit<List<JenisPinjaman>> {
  // String url = "https://www.boredapi.com/api/activity";
  JenisPinjamanCubit() : super([]);

  String selectedPinjaman = "0";

  List<JenisPinjaman> listJenisPinjamanModel = <JenisPinjaman>[];

  void setSelectedPinjaman(String pinjaman) {
    selectedPinjaman = pinjaman;
    fetchData();
  }

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    listJenisPinjamanModel.clear();
    var data = json["data"];
    for (var val in data) {
      var id = val["id"];
      var nama = val["nama"];
      listJenisPinjamanModel.add(JenisPinjaman(id: id, nama: nama));
    }

    emit([]);
  }

  void fetchData() async {
    String url = "http://178.128.17.76:8000/jenis_pinjaman/$selectedPinjaman";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<JenisPinjamanCubit>(
          create: (_) => JenisPinjamanCubit(),
        ),
        // Tambahkan BlocProvider lainnya jika diperlukan
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App P2P',
      routes: {
        '/': (context) => MyHome(),
        '/detail': (context) => Detail(id: "1")
      },
    );
  }
}

//perlu  dipisah karena Navigator perlu punya parent Material App
class MyHome extends StatelessWidget {
  MyHome({Key? key}) : super(key: key);

  final List<DropdownMenuItem<String>> jenisPinjaman = [
    const DropdownMenuItem<String>(
      value: "0",
      child: Text("Pilih jenis pinjaman"),
    ),
    const DropdownMenuItem<String>(
      value: "1",
      child: Text("Jenis pinjaman 1"),
    ),
    const DropdownMenuItem<String>(
      value: "2",
      child: Text("Jenis pinjaman 2"),
    ),
    const DropdownMenuItem<String>(
      value: "3",
      child: Text("Jenis pinjaman 3"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final JenisPinjamanCubit itemCubit =
        BlocProvider.of<JenisPinjamanCubit>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My App P2P'),
        ),
        body: Center(
            child: Column(children: [
          const Text(
              "2100137,Muhamad Nur Yasin Amadudin; 2108927,Muhammad Fahru Rozi; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang"),
          DropdownButton<String>(
            value: itemCubit.selectedPinjaman,
            onChanged: (String? newValue) {
              itemCubit.setSelectedPinjaman(newValue!);
            },
            items: jenisPinjaman,
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: BlocBuilder<JenisPinjamanCubit, List<JenisPinjaman>>(
              buildWhen: (previousState, state) {
                return true;
              },
              builder: (context, model) {
                if (itemCubit.listJenisPinjamanModel.isNotEmpty &&
                    itemCubit.selectedPinjaman != "0") {
                  return ListView.builder(
                    itemCount: itemCubit.listJenisPinjamanModel.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(1),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.store),
                              title: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    itemCubit
                                        .listJenisPinjamanModel[index].nama,
                                  )),
                              subtitle: Text(
                                'id: ' +
                                    itemCubit.listJenisPinjamanModel[index].id,
                              ),
                              trailing: GestureDetector(
                                child: const Icon(Icons.more_vert),
                                onTap: () {
                                  Navigator.of(context).pushNamed("/detail", arguments: itemCubit.listJenisPinjamanModel[index].id);
                                },
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed("/detail", arguments: itemCubit.listJenisPinjamanModel[index].id);
                              },
                            ),
                          ));
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ])));
  }
}
