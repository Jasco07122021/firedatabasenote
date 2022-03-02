import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class HiveDB{
  static String nameDB = "GK";
  static var box = Hive.box(nameDB);


  ///methods
  static putUser(User user){
    box.put("user_id",user.uid);
  }

  static getUser(){
    String userId = box.get("user_id");
    return userId;
  }

  static removeUser(){
    box.delete("user_id");
  }
}