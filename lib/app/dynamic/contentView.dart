import 'dart:convert';

import 'package:elevateshop/app/constant/lovebutton.dart';
import 'package:elevateshop/app/model/model.dart';
import 'package:elevateshop/app/modules/addcontent/views/contentdata.dart';
import 'package:elevateshop/app/modules/addcontent/views/editcontent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

class ContentViewData extends StatefulWidget {
  const ContentViewData({Key? key}) : super(key: key);

  @override
  State<ContentViewData> createState() => _ContentViewDataState();
}

class _ContentViewDataState extends State<ContentViewData> {
  final list = <TampilContent>[];
  var loading = false;
  bool _refreshing = false;
  Future<void> _onRefresh() async {
    await _lihatdata();
  }

  _delete(String id_content) async {
    final url = Uri.parse('http://192.168.1.18/elevated/delete.php');
    final response = await http.post(url, body: {"id_content": id_content});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['messege'];
    if (value == 1) {
      _lihatdata();
    } else {
      print(pesan);
    }
  }

  _dialogdelete(String id_content) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  'Apakaha anda yakin ingin menghapus file?',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No'),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _delete(id_content);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ya',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final url = Uri.parse('http://192.168.1.18/elevated/detileContent.php');
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
    final url = 'http://192.168.1.18/elevated/upload/';
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 290),
            itemCount: list.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (_, index) {
              final item = list[index];
              return InkWell(
                onDoubleTap: () {
                  _dialogdelete(item.id_content);
                },
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentData(
                                description: item.descripton,
                                price: item.price,
                                title: item.title,
                                image: url + item.image,
                              )));
                },
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditContent(item)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        child: Image.network(
                          url + item.image,
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          item.title.length > 15
                              ? '${item.title.substring(0, 15)}...'
                              : item.title,
                        ),
                        subtitle: Text(
                          item.descripton.length > 15
                              ? '${item.descripton.substring(0, 15)}...'
                              : item.descripton,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("\$ ${item.price}"),
                            LoveIcon(
                              isLiked: false,
                              onTap: () {
                                print('Love button tapped!');
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
