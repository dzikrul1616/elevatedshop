import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/dynamic/contentView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LaptopView extends StatefulWidget {
  const LaptopView({Key? key}) : super(key: key);

  @override
  State<LaptopView> createState() => _LaptopViewState();
}

class _LaptopViewState extends State<LaptopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        title: Text(
          "Laptop",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ContentViewData(),
            ],
          ),
        ),
      ),
    );
  }
}
