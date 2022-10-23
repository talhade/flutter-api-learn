import 'package:api_ogren/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  Future<List<UserModel>> _getUserList() async {
    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/users');
      List<UserModel> _userList = [];
      if (response.statusCode == 200) {
        _userList =
            (response.data as List).map((e) => UserModel.fromMap(e)).toList();
      }
      return _userList;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  late Future<List<UserModel>> _userList;

  //! HER SETSTATEDE TEKRAR ÇALIŞMASINI ENGELEMEK ICIN: yeni bir future tanımlıyoruz ve initstate'de asıl futuremizi buna veriyoruz.
  //! future buildere de bu initstate'de tanımlanmış futuremizi veriyoruz
  @override
  void initState() {
    super.initState();
    _userList = _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<UserModel>>(
        future: _userList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userList = snapshot.data!;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var _user = userList[index];
                return Card(
                  child: ListTile(
                    title: Text(_user.name),
                    subtitle: Text(_user.address.toString()),
                    leading: CircleAvatar(
                        child: Text(
                      _user.id.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    )),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
