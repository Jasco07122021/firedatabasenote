import 'package:firebase_database/firebase_database.dart';
import 'package:firedatabasenote/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RTDBServer {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> putPost(PostModel post) async {
    _database.child("post").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<PostModel>> getPost(String id) async {
    List<PostModel> list = [];
    Query _query =
    _database.child('post').orderByChild('id').equalTo(id);
    var result = await _query.once();
    for (var element in result.snapshot.children) {
      list.add(PostModel.fromJson(Map<dynamic,dynamic>.from(element.value as Map<dynamic,dynamic>)));
    }
    return list;
  }

  static deletePost({key}){
    _database.child(key).remove();
  }

  static updatePost(PostModel post,String key,BuildContext context)async{
      _database.child("post").child(key).set(post.toJson());
      Navigator.pop(context);
  }
}
