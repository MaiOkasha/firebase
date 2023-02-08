import 'package:firebase_storage/firebase_storage.dart';

enum ProcessType { create, delete }

abstract class CrudState {}

class LoadingState extends CrudState {}

class ReadState extends CrudState {
  List<Reference> data;

  ReadState({required this.data});
}

class ProcessState extends CrudState {
  final ProcessType processType;
  final String message;
  final bool status;

  ProcessState({
    required this.processType,
    required this.message,
    required this.status,
  });
}
