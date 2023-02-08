import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp12_firebase/firebase/fb_auth_controller.dart';
import 'package:vp12_firebase/firebase/fb_fire_store_controller.dart';
import 'package:vp12_firebase/firebase/fb_notifications.dart';
import 'package:vp12_firebase/models/note.dart';
import 'package:vp12_firebase/screens/app/note_screen.dart';
import 'package:vp12_firebase/utils/helpers.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with Helpers, FbNotifications {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'NOTES',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(),
                ),
              );
            },
            icon: Icon(Icons.note_add),
          ),
          IconButton(
            onPressed: () async {
              await FbAuthController().signOut();
              //A => B => C => D
              //A => B => F

              //A => B => C => D
              //F

              //home => Cart => Payment => Success
              //home => settings
              //pushNamedAndRemoveUntil(context, '/settings',(route) => route.settings.name == '/home);
              //pushNamedAndRemoveUntil(context, '/settings',(route) => false);

              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/F', (route) => route.settings.name == '/B');

              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/images_screen');
            },
            icon: Icon(Icons.image),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Note>>(
          stream: FbFirestoreController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      navigateToUpdateNoteScreen(snapshot, index);
                    },
                    leading: Icon(Icons.note),
                    title: Text(snapshot.data!.docs[index].data().title),
                    subtitle: Text(snapshot.data!.docs[index].data().info),
                    trailing: IconButton(
                      onPressed: () async =>
                          await _deleteNote(snapshot.data!.docs[index].id),
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("NO DATA"),
              );
            }
          }),
    );
  }

  Future<void> _deleteNote(String id) async {
    bool deleted = await FbFirestoreController().delete(path: id);
    String message =
        deleted ? 'Note deleted successfully' : 'Note delete failed!';
    showSnackBar(context, message: message, error: !deleted);
  }

  void navigateToUpdateNoteScreen(
      AsyncSnapshot<QuerySnapshot<Note>> snapshot, int index) {
    QueryDocumentSnapshot<Note> noteSnapshot = snapshot.data!.docs[index];
    Note note = noteSnapshot.data();
    note.id = noteSnapshot.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(
          note: note,
        ),
      ),
    );
  }
}
