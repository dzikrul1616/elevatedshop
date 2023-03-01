import 'dart:convert';
import 'dart:io';
import 'package:elevateshop/app/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:elevateshop/app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditContent extends StatefulWidget {
  final TampilContent tampilcontent;

  EditContent(this.tampilcontent);

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  late String _imageUrl;
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String title, price, description, id_users, id_content;
  late TextEditingController txtTitle, txtPrice, txtDescription;

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  check() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _submitForm();
    } else {}
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final url = Uri.parse('http://192.168.1.18/elevated/update.php');
    final request = http.MultipartRequest('POST', url);

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );
    }

    request.fields.addAll({
      'title': title,
      'price': price,
      'description': description,
      'id_content': id_content,
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final responseJson = json.decode(responseString);
      Navigator.pop(context);
      print(responseJson);
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_users = preferences.getString("id_users")!;
    });
    txtTitle = TextEditingController(text: widget.tampilcontent.title);
    txtPrice = TextEditingController(text: widget.tampilcontent.price);
    txtDescription =
        TextEditingController(text: widget.tampilcontent.descripton);
  }

  @override
  void initState() {
    super.initState();
    getPref();

    id_content = widget.tampilcontent.id_content;
    title = widget.tampilcontent.title;
    price = widget.tampilcontent.price;
    description = widget.tampilcontent.descripton;
  }

  @override
  Widget build(BuildContext context) {
    final url = 'http://192.168.1.18/elevated/upload/';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        title: Text('Update Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _image == null
                        ? (widget.tampilcontent.image! == null
                            ? Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 50.0,
                              )
                            : Image.network(
                                url + widget.tampilcontent.image,
                                fit: BoxFit.cover,
                              ))
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.tampilcontent.title,
                  onSaved: (value) => title = value!,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Color(0xffF2F2F2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                    hintText: 'Title',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Harap isi judul';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.tampilcontent.descripton,
                  onSaved: (value) => description = value!,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Color(0xffF2F2F2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Harap isi deskripsi';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  initialValue: widget.tampilcontent.price,
                  onSaved: (value) => price = value!,
                  decoration: InputDecoration(
                    hintText: 'Price',
                    prefixText: " \$ ",
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Color(0xffF2F2F2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Harap isi harga';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: check,
                    child: Text('Update Data'),
                    style: ElevatedButton.styleFrom(primary: appPrimary),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
