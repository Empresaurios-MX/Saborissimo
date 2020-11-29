import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saborissimo/data/model/Memory.dart';
import 'package:saborissimo/data/service/MemoriesDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/utils/utils.dart';

class AddMemory extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _AddMemoryState createState() => _AddMemoryState();
}

class _AddMemoryState extends State<AddMemory> {
  File _selectedPicture;

  bool _working;
  String _title;

  @override
  void initState() {
    _working = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title:
            Text(Names.createMemoryAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButton: createFAB(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: widget._key,
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showPicker(context),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Palette.primaryLight,
                    child: createPicture(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: Utils.createHint('Título *'),
                  maxLength: 255,
                  style: Styles.body(Colors.black),
                  onChanged: (value) => setState(() => _title = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: Text(
                    '* Campos obligatorios',
                    style: Styles.body(Colors.black54),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(bool empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  void _selectFromCamera() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 960,
        imageQuality: 50);

    setState(() {
      _selectedPicture = file;
    });
  }

  void _selectFromGallery() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 960,
        imageQuality: 50);

    setState(() {
      _selectedPicture = file;
    });
  }

  void _validateForm() {
    if (widget._key.currentState.validate()) {
      if (_selectedPicture == null) {
        Utils.showSnack(widget._scaffoldKey, 'Debe seleccionar una imagen');
      } else {
        setState(() => _working = true);
        uploadToFirebase(_selectedPicture);
      }
    }
  }

  Future uploadToFirebase(File imageToUpload) async {
    DateTime now = DateTime.now();
    String date =
        DateTime(now.year, now.month, now.day).toString().substring(0, 10);
    String fileName = 'memory_' + _title + '_' + date;

    Reference firebaseStorageRef;
    UploadTask uploadTask;
    TaskSnapshot taskSnapshot;

    Firebase.initializeApp().then((value) async => {
          firebaseStorageRef =
              FirebaseStorage.instance.ref().child('memories/$fileName'),
          uploadTask = firebaseStorageRef.putFile(_selectedPicture),
          taskSnapshot = await uploadTask.whenComplete(() => null),
          taskSnapshot.ref
              .getDownloadURL()
              .then((url) => saveMemory(url, date))
              .catchError((_) => setState(() => _working = false)),
        });
  }

  void saveMemory(String url, String date) {
    MemoriesDataService service = MemoriesDataService('');

    if (url != null && url.isNotEmpty) {
      final Memory memory = Memory(0, _title, url, date);
      service.post(memory).then(
            (success) => {if (success) showDoneDialog() else showErrorDialog()},
          );
    } else {
      setState(() => _working = false);
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(
          'Su recuerdo ha sido publicada con exito',
          textAlign: TextAlign.center,
          style: Styles.subTitle(Colors.black),
        ),
        content: Icon(
          Icons.done,
          color: Palette.done,
          size: 80,
        ),
      ),
    ).then((_) => Navigator.pop(context));
  }

  void showErrorDialog() {
    setState(() => _working = false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
          title: Text(
            'Ha ocurrido un error, intente de nuevo',
            textAlign: TextAlign.center,
            style: Styles.subTitle(Colors.black),
          ),
          content: Icon(
            Icons.error,
            color: Palette.todo,
            size: 80,
          )),
    );
  }

  Widget createFAB() {
    if (_working) {
      return Center();
    }

    return FloatingActionButton(
      backgroundColor: Palette.accent,
      child: Icon(Icons.file_upload),
      onPressed: _validateForm,
    );
  }

  Widget createPicture() {
    if (_selectedPicture != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.file(
          _selectedPicture,
          width: 190,
          height: 190,
          fit: BoxFit.fill,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Palette.primaryMedium,
        borderRadius: BorderRadius.circular(100),
      ),
      width: 190,
      height: 190,
      child: Icon(
        Icons.add_a_photo,
        color: Colors.white,
        size: 100,
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library, color: Palette.primary),
              title: Text(
                'Seleccionar de la galeria',
                style: Styles.body(Colors.black),
              ),
              onTap: () => {_selectFromGallery(), Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.photo_camera, color: Palette.primary),
              title: Text(
                'Tomar una foto ahora',
                style: Styles.body(Colors.black),
              ),
              onTap: () => {_selectFromCamera(), Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
