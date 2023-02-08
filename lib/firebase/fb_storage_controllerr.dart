import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FbStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UploadTask save({required File file}) {
    return _firebaseStorage
        .ref('images/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
  }

  Future<bool> delete({required String path}) async {
    return _firebaseStorage
        .ref(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<List<Reference>> read() async {
    ListResult listResult = await _firebaseStorage.ref('images').listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }
}
