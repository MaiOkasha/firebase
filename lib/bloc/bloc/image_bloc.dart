import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp12_firebase/bloc/events/crud_event.dart';
import 'package:vp12_firebase/bloc/states/crud_state.dart';
import 'package:vp12_firebase/firebase/fb_storage_controllerr.dart';

class ImageBloc extends Bloc<CrudEvent, CrudState> {
  ImageBloc(CrudState initialState) : super(initialState) {
    on<CreateEvent>(_createEvent);
    on<ReadEvent>(_readEvent);
    on<DeleteEvent>(_deleteEvent);
  }

  List<Reference> references = <Reference>[];
  final FbStorageController _storageController = FbStorageController();

  void _createEvent(CreateEvent event, Emitter emit) async {
    UploadTask uploadTask = _storageController.save(file: event.file);
    await uploadTask.snapshotEvents.listen((TaskSnapshot event) {
      if (event.state == TaskState.success) {
        references.add(event.ref);
        emit(ProcessState(
            processType: ProcessType.create,
            message: 'Uploaded successfully',
            status: true));
      } else if(event.state == TaskState.error){
        emit(ProcessState(
            processType: ProcessType.create,
            message: 'Upload failed!',
            status: false));
      }
    }).asFuture();
  }

  void _readEvent(ReadEvent event, Emitter emit) async {
    references = await _storageController.read();
    emit(ReadState(data: references));
  }

  void _deleteEvent(DeleteEvent event, Emitter emit) async {
    // bool deleted = await _storageController.delete(path: event.refPath);
    // if(deleted) {
    //   int index = references.indexWhere((element) => element.fullPath == event.refPath);
    //   if(index != -1) {
    //     references.removeAt(index);
    //   }
    // }
    bool deleted = await _storageController.delete(path: references[event.index].fullPath);
    print(deleted);
    if(deleted) {
      references.removeAt(event.index);
      emit(ReadState(data: references));
    }
    String message = deleted ? 'Deleted successfully' : 'Delete failed!';
    emit(ProcessState(
      processType: ProcessType.delete,
      message: message,
      status: deleted,
    ));
  }
}
