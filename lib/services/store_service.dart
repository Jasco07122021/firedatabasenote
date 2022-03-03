import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:logger/logger.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = 'post_image';

  static Future<String?> uploadImg(File? _image,{String? oldUrl}) async {
    if (oldUrl != null) {
     await deleteStorage(oldUrl);
    }
    Logger().d(_image);
    String? url;
    String imgName = "image_" + DateTime.now().toString();
    Reference fireBaseStorageRef = _storage.child(folder).child(imgName);
    if(_image != null) {
      await fireBaseStorageRef.putFile(_image).then((p0) async {
      if (p0.metadata != null) {
        final String downloadUrl = await p0.ref.getDownloadURL();
        url = downloadUrl;
      } else {
        url = null;
      }
    });
    }
    return url;
  }

  static deleteStorage(String oldUrl)async{
      var fileUrl = Uri.decodeFull(Path.basename(oldUrl))
          .replaceAll(RegExp(r'(\?alt).*'), '');
      var fileUrlNew = Uri.decodeFull(Path.basename(fileUrl))
          .replaceAll(RegExp(r'post_image/'), '');
      Reference photoRef = _storage.child(folder).child(fileUrlNew);
      try {
        await photoRef.delete();
      } catch (e) {}
    }

}
