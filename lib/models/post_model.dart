

import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  String name = FirebaseAuth.instance.currentUser!.displayName!;
  late String id;
  late String title;
  late String content;
  String? imgUser;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    this.imgUser,
  });

  PostModel.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        title = json["title"],
        content = json["content"],
        imgUser = json['imgUser'];

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'imgUser': imgUser,
      };
}
