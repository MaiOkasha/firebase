import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp12_firebase/bloc/bloc/image_bloc.dart';
import 'package:vp12_firebase/bloc/states/crud_state.dart';
import 'package:vp12_firebase/firebase/fb_notifications.dart';
import 'package:vp12_firebase/screens/app/notes_screen.dart';
import 'package:vp12_firebase/screens/auth/forget_password_screen.dart';
import 'package:vp12_firebase/screens/auth/login_screen.dart';
import 'package:vp12_firebase/screens/auth/register_screen.dart';
import 'package:vp12_firebase/screens/images/images_screen.dart';
import 'package:vp12_firebase/screens/images/upload_image_screen.dart';
import 'package:vp12_firebase/screens/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FbNotifications.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ImageBloc(LoadingState())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/forget_password_screen': (context) => const ForgetPasswordScreen(),
          '/notes_screen': (context) => const NotesScreen(),
          '/images_screen': (context) => const ImagesScreen(),
          '/upload_image_screen': (context) => const UploadImageScreen(),
        },
      ),
    );
  }
}
