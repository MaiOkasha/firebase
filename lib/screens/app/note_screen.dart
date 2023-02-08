import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp12_firebase/firebase/fb_fire_store_controller.dart';
import 'package:vp12_firebase/models/note.dart';
import 'package:vp12_firebase/utils/helpers.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          getScreenTitle(),
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          TextField(
            controller: _titleTextController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Title',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black45,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _infoTextController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Info',
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black45,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await _performSave(),
            child: Text('SAVE'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(0, 50),
            ),
          )
        ],
      ),
    );
  }

  String getScreenTitle() => isNewNote() ? 'Create Note' : 'Update Note';

  Future<void> _performSave() async {
    if (checkData()) {
      await _save();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _save() async {
    bool status = isNewNote()
        ? await FbFirestoreController().create(note: note)
        : await FbFirestoreController().update(note: note);

    String message = status ? 'Note saved successfully' : 'Note save failed!';
    showSnackBar(context, message: message, error: !status);
    if(isNewNote()) {
      _clear();
    }else {
      Navigator.pop(context);
    }
  }

  void _clear() {
    _titleTextController.text = '';
    _infoTextController.text = '';
  }

  Note get note {
    Note note = isNewNote() ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }

  bool isNewNote() => widget.note == null;
}
