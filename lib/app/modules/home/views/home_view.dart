import 'dart:convert';

import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/dynamic/content.dart';
import 'package:elevateshop/app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final list = <TampilContent>[];
  var loading = false;
  Future<void> _onRefresh() async {
    await _lihatdata();
  }

  Future _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final url = Uri.parse('http://192.168.8.101/elevated/detileContent.php');
    final response = await http.get(url);

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TampilContent(
          api['id_content'],
          api['image'],
          api['title'],
          api['price'],
          api['description'],
          api['date_content'],
          api['id_users'],
          api['username'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _lihatdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimary,
          title: const Text('Laptop Gaming'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                child: Column(
                  children: [
                    Content()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
