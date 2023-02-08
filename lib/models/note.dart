import 'package:flutter/foundation.dart';

class Note {
  late String id;
  late String title;
  late String info;

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    info = map['info'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['info'] = info;
    return map;
  }
}
