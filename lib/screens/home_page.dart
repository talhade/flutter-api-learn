import 'dart:convert';

import 'package:api_ogren/models/araba_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Local Json İşlemleri';
  late Future<List<Araba>> _listeyiOlustur;

  @override
  void initState() {
    super.initState();
    _listeyiOlustur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          debugPrint('Tıklandı');
          title = 'Tıklandı';
        });
      }),
      body: FutureBuilder<List<Araba>>(
        //! initial data asıl kod çalışana kadar gösterilcek şeyi gösterir örneğin instagramın yeni postlar yüklenene kadar eski postları göstermesi gibi
        initialData: [
          Araba(
              arabaAdi: 'a',
              ulke: 'a',
              kurulusYili: 1000,
              model: [Model(modelAdi: 'Juke', fiyat: 1234, benzinli: true)])
        ],
        future: _listeyiOlustur,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Araba> arabaListesi = snapshot.data!;
            return ListView.builder(
                itemCount: arabaListesi.length,
                itemBuilder: (context, index) {
                  Araba _araba = arabaListesi[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        _araba.arabaAdi.toString(),
                      ),
                      subtitle: Text(_araba.ulke),
                      leading: CircleAvatar(
                        child: Text(_araba.model[0].modelAdi.toString()),
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Araba>> arabalarJsonOku() async {
    try {
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');

      var jsonObj = jsonDecode(okunanString);

      /*
    print(okunanString);
    print('**********************************');
    List arabaListesi = jsonObj;
    print(jsonObj);
    print('**********************************');

    print(arabaListesi[0]['model'][0]['model_adi'].toString());
    */

      List<Araba> tumArabalar =
          (jsonObj as List).map((arabaMap) => Araba.fromMap(arabaMap)).toList();
      print(tumArabalar.length.toString());

      return tumArabalar;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
