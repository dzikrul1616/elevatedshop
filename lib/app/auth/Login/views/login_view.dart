import 'dart:convert';
import 'package:elevateshop/app/auth/Login/views/register_view.dart';
import 'package:elevateshop/app/modules/profil/views/profil_view.dart';
import 'package:http/http.dart' as http;
import 'package:elevateshop/app/bottomBar/bottombar.dart';
import 'package:elevateshop/app/constant/color.dart';
import 'package:elevateshop/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

enum LoginStatus { notSignin, signIn }

class _LoginViewState extends State<LoginView> {
  bool _securedText = true;
  final _key = new GlobalKey<FormState>();
  bool _isLoading = false;

  LoginStatus _loginStatus = LoginStatus.notSignin;
  late String email, password;

  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    var url = Uri.parse('http://192.168.1.18/elevated/login.php');
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['messege'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, emailAPI);
      });
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: appPrimary,
        ),
      );
    } else {
      print(pesan);
    }
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignin;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  savePref(int value, String username, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.commit();
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
      _loginStatus = LoginStatus.notSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignin:
        return Scaffold(
            body: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Padding(
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
                                "Please login first",
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
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
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
                              Text('Belum punya akun?'),
                              const SizedBox(
                                width: 2.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterView()));
                                },
                                child: Text(
                                  'Daftar sekarang',
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
                                child: Text('LOGIN'),
                                style: ElevatedButton.styleFrom(
                                    primary: appPrimary),
                              )),
                        ],
                      ),
                    ),
            ),
          ),
        ));
      case LoginStatus.signIn:
        return BottomBar(signOut);
    }
  }
}
