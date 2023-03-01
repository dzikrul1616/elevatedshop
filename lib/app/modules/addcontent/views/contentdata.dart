import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/constant/lovebutton.dart';
import 'package:elevateshop/app/constant/rating.dart';
import 'package:elevateshop/app/modules/addcontent/views/editcontent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ContentData extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String price;

  ContentData({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  State<ContentData> createState() => _ContentDataState();
}

class _ContentDataState extends State<ContentData> {
  bool _showFullDescription = false;

  String _truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    } else {
      return description.substring(0, maxLength) + '...';
    }
  }

  void _toggleDescription() {
    setState(() {
      _showFullDescription = !_showFullDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Add to Cart',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                primary: appPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey[700],
                      size: 18,
                    ),
                    iconSize: 40,
                  ),
                  Expanded(
                      child: ListTile(
                    title: Text(
                      'Komputer',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  )),
                  IconButton(
                    onPressed: () {
                     
                    },
                    icon: Icon(Icons.edit),
                    color: Colors.grey[700],
                    iconSize: 18,
                  ),
                ],
              ),
              bottom: PreferredSize(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration: BoxDecoration(
                        color: appBackground,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                  ),
                  preferredSize: Size.fromHeight(30)),
              pinned: true,
              backgroundColor: appBackground,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  widget.image,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.price}",
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.bold),
                      ),
                      LoveIcon(
                        isLiked: false,
                        onTap: () {
                          print('Love button tapped!');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      StarRating(
                          starCount: 5,
                          rating: 5,
                          color: Colors.orange,
                          size: 30.0,
                          onRatingChanged: (rating) {}),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "5.0",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: _toggleDescription,
                    child: Text(
                      _showFullDescription
                          ? widget.description
                          : _truncateDescription(
                              widget.description,
                              140,
                            ),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(height: 1.5, fontSize: 14),
                    ),
                  ),
                  if (!_showFullDescription)
                    const SizedBox(
                      height: 10.0,
                    ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 1,
                          offset: Offset(0, 5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            left: 15,
                            top: 15,
                            child: CircleAvatar(
                              radius: 15,
                            )),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Positioned(
                          top: 18,
                          left: 55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adbor Khaleed',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              StarRating(
                                  starCount: 5,
                                  rating: 5,
                                  color: Colors.orange,
                                  size: 18.0,
                                  onRatingChanged: (rating) {}),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                "the product is very good, fits on my skin \nand also the delivery is very fast, the...",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.5,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 18,
                          child: Text(
                            "SEE ALL",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: appGreen),
                  //         child: Center(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(
                  //                 Icons.edit,
                  //                 size: 24.0,
                  //                 color: appBackground,
                  //               ),
                  //               const SizedBox(
                  //                 width: 10.0,
                  //               ),
                  //               Text(
                  //                 'Edit',
                  //                 style: TextStyle(color: appBackground),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 20.0,
                  //     ),
                  //     Flexible(
                  //       flex: 1,
                  //       child: Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: appYoungGreen),
                  //         child: Center(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(
                  //                 Icons.delete,
                  //                 size: 24.0,
                  //                 color: appBackground,
                  //               ),
                  //               const SizedBox(
                  //                 width: 10.0,
                  //               ),
                  //               Text(
                  //                 'Delete',
                  //                 style: TextStyle(color: appBackground),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ))
          ],
        ));
  }
}
