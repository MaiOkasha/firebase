import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp12_firebase/firebase/fb_auth_controller.dart';
import 'package:vp12_firebase/models/fb_response.dart';
import 'package:vp12_firebase/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  bool _obscureText = true;
  // late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  String _gender = 'M';

  @override
  void initState() {
    super.initState();
    // _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'REGISTER',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            'Create new account..',
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
            'Create account to start using app',
            style: GoogleFonts.nunito(
              color: Colors.black45,
              fontWeight: FontWeight.w300,
              height: 1,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 20),
          // TextField(
          //   controller: _fullNameTextController,
          //   keyboardType: TextInputType.emailAddress,
          //   decoration: InputDecoration(
          //       hintText: 'Full name',
          //       prefixIcon: const Icon(Icons.person),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: BorderSide(
          //           color: Colors.blue.shade300,
          //           width: 0.8,
          //         ),
          //       )),
          // ),
          // const SizedBox(height: 10),
          TextField(
            controller: _emailTextController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 0.8,
                  ),
                )),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordTextController,
            keyboardType: TextInputType.text,
            obscureText: _obscureText,
            textInputAction: TextInputAction.go,
            onSubmitted: (String value) async {
              await _performRegister();
            },
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue.shade300,
                  width: 0.8,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue.shade800,
              minimumSize: Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async => await _performRegister(),
            child: Text('REGISTER'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRegister() async {
    if (checkData()) {
      await _register();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _register() async {
    FbResponse fbResponse = await FbAuthController().createAccount(email: _emailTextController.text, password: _passwordTextController.text);
    showSnackBar(context, message: fbResponse.message, error: ! fbResponse.status);
    if(fbResponse.status) {
      Navigator.pop(context);
    }
  }
}
