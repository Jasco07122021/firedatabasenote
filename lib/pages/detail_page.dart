import 'dart:io';

import 'package:firedatabasenote/models/post_model.dart';
import 'package:firedatabasenote/services/hive_db.dart';
import 'package:firedatabasenote/services/rtdb_service.dart';
import 'package:firedatabasenote/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static String id = "/detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? _image;
  final picker = ImagePicker();
  bool isLoading = false;

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerContent = TextEditingController();

  _addPost() async {
    String title = controllerTitle.text.trim().toString();
    String content = controllerContent.text.trim().toString();
    if (title.isEmpty || content.isEmpty || _image == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var id = await HiveDB.getUser();
    await StoreService.uploadImg(_image!).then((value) => {
          RTDBServer.putPost(PostModel(
                  id: id, title: title, content: content, imgUser: value!))
              .then((value) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          })
        });
  }

  _getPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Logger().d("No image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getPhoto,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, blurRadius: 3)
                        ]),
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Image.asset("assets/images/img.png"),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                _textField(text: "Title", controller: controllerTitle),
                const SizedBox(height: 20),
                _textField(text: "Content", controller: controllerContent),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: _addPost,
                  child: const Text("Add"),
                  minWidth: double.infinity,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          isLoading
              ? const LinearProgressIndicator(
                  backgroundColor: Colors.red,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.amber,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  TextField _textField({text, controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
      ),
    );
  }
}
