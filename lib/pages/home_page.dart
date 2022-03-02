import 'package:firedatabasenote/models/post_model.dart';
import 'package:firedatabasenote/pages/detail_page.dart';
import 'package:firedatabasenote/services/auth_service.dart';
import 'package:firedatabasenote/services/hive_db.dart';
import 'package:firedatabasenote/services/rtdb_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late String userId;
  List<PostModel> list = [];

  _getPost() async {
    RTDBServer.getPost(userId).then((value) => {_getUIPost(value)});
  }

  _getUIPost(List<PostModel> posts) {
    setState(() {
      list = posts;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _getPost();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = HiveDB.getUser();
    _getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOutUser(context);
              },
              icon: const Icon(Icons.replay)),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: (){
                  Navigator.pushNamed(context, DetailPage.id);
                },
                textColor: Colors.white,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(list[index].imgUser)
                ),
                title: Text(list[index].title),
                subtitle: Text(list[index].content),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, DetailPage.id);
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }
}
