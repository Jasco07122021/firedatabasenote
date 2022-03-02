import 'dart:convert';

class PostModel {
  late String id;
  late String title;
  late String content;
  late String imgUser;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imgUser,
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
