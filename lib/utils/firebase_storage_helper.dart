import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  final File imageToUpload;
  final String fileName;
  final String location;
  final Function onSuccess;
  final Function onFailure;

  FirebaseStorageHelper({
    this.imageToUpload,
    this.fileName,
    this.location,
    this.onSuccess,
    this.onFailure,
  });

  Future uploadFile() async {
    Reference firebaseStorageRef;
    UploadTask uploadTask;
    TaskSnapshot taskSnapshot;

    Firebase.initializeApp().then((value) async =>
    {
      firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$location$fileName'),
      uploadTask = firebaseStorageRef.putFile(imageToUpload),
      taskSnapshot = await uploadTask.whenComplete(() => null),
      taskSnapshot.ref
          .getDownloadURL()
          .then((url) => onSuccess(url))
          .catchError((error) => onFailure(error)),
    });
  }

  static void deleteFile(String fileName) {
    String file = fileName.split('/o/')[1]
        .replaceAll('%2F', '/')
        .replaceAll('%20', ' ')
        .split('?alt')[0];

    Firebase.initializeApp().then(
          (_) => FirebaseStorage.instance.ref().child(file).delete(),
    );
  }
}
