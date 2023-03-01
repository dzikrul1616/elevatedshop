import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/dynamic/contentView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class KomputerView extends StatefulWidget {
  const KomputerView({Key? key}) : super(key: key);

  @override
  State<KomputerView> createState() => _KomputerViewState();
}

class _KomputerViewState extends State<KomputerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        title: Text(
          "Komputer",
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
