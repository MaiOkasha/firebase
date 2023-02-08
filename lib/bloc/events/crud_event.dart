import 'dart:io';

abstract class CrudEvent {}

class CreateEvent extends CrudEvent {
  final File file;

  CreateEvent({required this.file});
}

class ReadEvent extends CrudEvent {}

class DeleteEvent extends CrudEvent {
  // final String refPath;
  final int index;

  DeleteEvent({required this.index});
}
