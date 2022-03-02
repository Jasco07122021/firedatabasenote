import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = 'post_image';

  static Future<String?> uploadImg(File _image) async {
    String? url;
    String imgName = "image_" + DateTime.now().toString();
    Reference fireBaseStorageRef = _storage.child(folder).child(imgName);
    await fireBaseStorageRef.putFile(_image).then((p0) async {
      if (p0.metadata != null) {
        final String downloadUrl = await p0.ref.getDownloadURL();
        url = downloadUrl;
      } else {
        url = null;
      }
    });
    return url;
  }
}
