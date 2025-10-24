import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proje1/models/urunler_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UrunlerModel? _urunler;
  List<Urun> _veriler = [];

  void _loadData() async {
    final dataString = await rootBundle.loadString("assets/files/data.json");
    final dataJson = jsonDecode(dataString);

    _urunler = UrunlerModel.fromJson(dataJson);
    _veriler = _urunler!.urunler;
    setState(() {});
  }

  void _filterData(int id) {
    _veriler = _urunler!.urunler
        .where((urunlerElaman) => urunlerElaman.kategori == id)
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _urunler == null
            ? const Text('Yükleniyor')
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [_kategoriView(), _urunlerView()],
              ),
      ),
    );
  }

  ListView _urunlerView() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _veriler.length,
      itemBuilder: (context, index) {
        final Urun urun = _veriler[index];
        return ListTile(
          leading: Image.network(
            urun.resim,
            width: 50,
            height: 100,
            fit: BoxFit.cover,
          ),
          title: Text(urun.isim),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Row _kategoriView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_urunler!.kategoriler.length, (index) {
        final kategori = _urunler!.kategoriler[index];
        return GestureDetector(
          onTap: () => _filterData(kategori.id),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(kategori.isim),
          ),
        );
      }),
    );
  }
}
