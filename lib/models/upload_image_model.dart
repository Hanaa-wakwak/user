import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery/services/auth.dart';

class UploadImageModel {
  final AuthBase auth;

  UploadImageModel({@required this.auth});

  String get uid => auth.uid;

  String get profileImage => auth.profileImage;


  Future<void> uploadImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      //profile_images
      FirebaseStorage storage = FirebaseStorage.instance;


      ///Upload image to firebase storage
      File image = File(result.files.single.path);
      UploadTask task = storage
          .ref()
          .child('profile_images/$uid/${result.names.single}')
          .putFile(image);

      String url;

      await task.whenComplete(() async {
        url = await task.snapshot.ref.getDownloadURL();
      });

      ///Update profile image
      await auth.editImage(url);
    } else {
      // User canceled the picker
    }
  }
}
