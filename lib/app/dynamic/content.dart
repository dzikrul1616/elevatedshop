import 'dart:convert';
import 'dart:math';
import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/kategori/android.dart';
import 'package:elevateshop/app/kategori/computer.dart';
import 'package:elevateshop/app/kategori/laptop.dart';
import 'package:elevateshop/app/kategori/service.dart';
import 'package:elevateshop/app/kategori/ssd.dart';
import 'package:elevateshop/app/modules/addcontent/views/contentdata.dart';
import 'package:elevateshop/app/modules/addcontent/views/editcontent.dart';
import 'package:http/http.dart' as http;
import 'package:elevateshop/app/constant/lovebutton.dart';
import 'package:elevateshop/app/model/model.dart';
import 'package:elevateshop/app/modules/addcontent/views/addcontent_view.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final list = <TampilContent>[];
  var loading = false;
  bool _refreshing = false;
  Future<void> _onRefresh() async {
    await _lihatdata();
  }

  var item = [
    "komputer",
    "android",
    "laptop",
    "ssd",
    "rakit komputer",
    "service"
  ];

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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo2.png',
                        width: 150,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          color: appPrimary,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Kategory",
                        style: TextStyle(
                          color: appGreen,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(),
                    child: Row(
                      children: List.generate(
                        item.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              _onItemTapped(index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  switch (item[index]) {
                                    case 'komputer':
                                      return KomputerView();
                                    case 'android':
                                      return AndroView();
                                    case 'laptop':
                                      return LaptopView();
                                    case 'ssd':
                                      return SsdView();
                                    case 'rakit komputer':
                                      return KomputerView();
                                    case 'service':
                                      return ServiceView();
                                    default:
                                      return Container();
                                  }
                                }),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                color: appPrimary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${item[index]}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Special",
                        style: TextStyle(
                          color: appGreen,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  bannerWidget(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Recomended",
                        style: TextStyle(
                          color: appGreen,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        // onTapCancel: () {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         content: Container(
                        //           height: 350,
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.circular(10.0),
                        //           ),
                        //           child: Column(
                        //             children: [
                        //               Image.network(
                        //                 url + item.image,
                        //                 height: 300,
                        //                 width: 300,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //               const SizedBox(
                        //                 height: 10.0,
                        //               ),
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   Text(
                        //                     item.title.length > 15
                        //                         ? '${item.title.substring(0, 15)}...'
                        //                         : item.title,
                        //                   ),
                        //                   LoveIcon(
                        //                     isLiked: false,
                        //                     onTap: () {
                        //                       print('Love button tapped!');
                        //                     },
                        //                   ),
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // },
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
            ),
          ),
        ),
      ),
    );
  }
}

class bannerWidget extends StatelessWidget {
  const bannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List items = [
          {
            "id": 1,
            "photo":
                "https://i.ibb.co/6NZ8dGk/Holiday-Travel-Agent-Promotion-Banner-Landscape.png",
            "onTap": (item) {},
          },
          {
            "id": 2,
            "photo": "https://i.ibb.co/5xfjdy9/Blue-Modern-Discount-Banner.png",
            "onTap": (item) {},
          },
          {
            "id": 3,
            "photo":
                "https://i.ibb.co/6Rvjyy1/Brown-Yellow-Free-Furniture-Promotion-Banner.png",
            "onTap": (item) {},
          }
        ];

        return SizedBox(
          height: 120.0,
          child: ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = items[index];
              return Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.7,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      item["photo"],
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16.0,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
