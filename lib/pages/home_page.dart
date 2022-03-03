import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firedatabasenote/models/post_model.dart';
import 'package:firedatabasenote/services/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as Path;
import '../services/auth_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home_page";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.ref().child("post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.replay),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: databaseRef.orderByChild("id"),
          defaultChild: const Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
            ),
          ),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            final json = snapshot.value as Map<dynamic, dynamic>;
            final  responseKey = snapshot.key;
            final response = PostModel.fromJson(json);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                                obj: response,keyObj: responseKey
                              )));
                },
                leading: response.imgUser == null
                    ? CircleAvatar(
                        child: Text(response.name[0]),
                        backgroundColor: Color(Random().nextInt(0xffffffff)),
                        foregroundColor: Colors.white,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(response.imgUser!),
                      ),
                title: _text(response: response.title, width: 0.4),
                subtitle: _text(response: response.content, width: 0.6),
                trailing: GestureDetector(
                  onTap: () {
                    databaseRef.child(responseKey!).remove();
                    StorageService.deleteStorage(response.imgUser!);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, DetailPage.id);
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }

  Widget _text({response, width}) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width * width,
          child: Text(
            response,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
