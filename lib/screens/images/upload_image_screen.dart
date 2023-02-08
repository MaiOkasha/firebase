import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp12_firebase/bloc/bloc/image_bloc.dart';
import 'package:vp12_firebase/bloc/events/crud_event.dart';
import 'package:vp12_firebase/bloc/states/crud_state.dart';
import 'package:vp12_firebase/utils/helpers.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> with Helpers {
  //TODO: Create XFILE? variable which will hold selected/captured image
  XFile? _pickedImage;

  //TODO: Create instance from ImagePicker
  late ImagePicker _imagePicker;

  //TODO: Create value variable for ProgressIndicator
  double? _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'UPLOAD IMAGE',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<ImageBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            current.processType == ProcessType.create,
        listener: (context, state) {
          state as ProcessState;
          _updateProgressValue(value: state.status ? 1 : 0);
          showSnackBar(context, message: state.message, error: !state.status);
        },
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 10,
              color: Colors.green,
              backgroundColor: Colors.green.shade100,
            ),
            Expanded(
              child: _pickedImage == null
                  ? Center(
                      child: IconButton(
                        onPressed: () async => await _pickImage(),
                        iconSize: 48,
                        icon: Icon(Icons.camera_enhance_outlined),
                      ),
                    )
                  : Image.file(
                      File(_pickedImage!.path),
                      // fit: BoxFit.cover,
                    ),
            ),
            ElevatedButton.icon(
              onPressed: () => _performImageUpload(),
              icon: Icon(Icons.cloud_upload),
              label: Text(
                'UPLOAD IMAGE',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _performImageUpload() {
    if (_checkData()) {
      _uploadImage();
    }
  }

  bool _checkData() {
    if (_pickedImage != null) {
      return true;
    }
    showSnackBar(context, message: 'Pick image to upload!', error: true);
    return false;
  }

  void _uploadImage() {
    _updateProgressValue();
    BlocProvider.of<ImageBloc>(context)
        .add(CreateEvent(file: File(_pickedImage!.path)));
  }

  void _updateProgressValue({double? value}) {
    setState(() => _progressValue = value);
  }
}
