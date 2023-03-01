import 'dart:convert';

import 'package:elevateshop/app/auth/Login/views/login_view.dart';
import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late String email, password, username;
  final _key = new GlobalKey<FormState>();

  bool _securedText = true;

  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
    ;
  }

  save() async {
    var url = Uri.parse('http://192.168.1.18/elevated/register.php');
    final response = await http.post(url, body: {
      "username": username,
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);
    int value = data["value"] ?? 0;
    String pesan = data["msg"];
    if (value == 0) {
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register berhasil! Silahkan login'),
          backgroundColor: appGreen,
        ),
      );
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register gagal!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Image.asset("assets/logo.png"),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Welcome!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: appPrimary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Please Register first",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: appGreen),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      onSaved: (e) => username = e!,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Username";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        prefixIconColor: appPrimary,
                        fillColor: Color(0xffF2F2F2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      onSaved: (e) => email = e!,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Email";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        prefixIconColor: appPrimary,
                        fillColor: Color(0xffF2F2F2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      onSaved: (e) => password = e!,
                      obscureText: _securedText,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert password";
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_securedText
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        fillColor: Color(0xffF2F2F2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah punya akun?'),
                      const SizedBox(
                        width: 2.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()));
                        },
                        child: Text(
                          'Login sekarang',
                          style: TextStyle(color: Color(0xff0000ff)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: check,
                        child: Text('REGISTER'),
                        style: ElevatedButton.styleFrom(primary: appPrimary),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//  late String email, password, username;
//   final _key = new GlobalKey<FormState>();

//   bool _securedText = true;

//   showHide() {
//     setState(() {
//       _securedText = !_securedText;
//     });
//   }

//   check() {
//     final form = _key.currentState;
//     if (form!.validate()) {
//       form.save();
//       save();
//     }
//     ;
//   }

//   save() async {
//     var url = Uri.parse('http://192.168.1.18/elevated/register.php');
//     final response = await http.post(url, body: {
//       "username": username,
//       "email": email,
//       "password": password,
//     });
//     final data = jsonDecode(response.body);
//     int value = data["value"];
//     String pesan = data["messege"];
//     if (value == 1) {
//       setState(() {
//         navigator!.pop(context);
//       });
//     } else {
//       print(pesan);
//     }
//   }