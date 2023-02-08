import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp12_firebase/models/note.dart';

class FbFirestoreController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  //CRUD
  Future<bool> create({required Note note}) async {
    return await _instance
        .collection('Notes')
        .add(note.toMap())
        .then((DocumentReference value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String path}) async {
    return _instance
        .collection('Notes')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> update({required Note note}) async {
    return _instance
        .collection("Notes")
        .doc(note.id)
        .update(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot<Note>> read() async* {
    // yield* _instance.collection('Notes').snapshots();
    yield* _instance
        .collection('Notes')
        .withConverter<Note>(
          fromFirestore: (snapshot, options) => Note.fromMap(snapshot.data()!),
          toFirestore: (Note note, options) => note.toMap(),
        )
        .snapshots();
  }
}
