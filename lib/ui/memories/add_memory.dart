import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Memory.dart';
import 'package:saborissimo/data/service/MemoriesDataService.dart';
import 'package:saborissimo/res/messages.dart';
import 'package:saborissimo/res/strings.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/utils/firebase_storage_helper.dart';
import 'package:saborissimo/utils/image_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/utils/validation_utils.dart';
import 'package:saborissimo/widgets/input/image_avatar.dart';
import 'package:saborissimo/widgets/input/text_field_empty.dart';
import 'package:saborissimo/widgets/material_dialog_neutral.dart';

class AddMemory extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _AddMemoryState createState() => _AddMemoryState();
}

class _AddMemoryState extends State<AddMemory> {
  ImageSelectorUtils selector;
  File _selectedPicture;

  bool _working;
  String _title;

  @override
  void initState() {
    _working = false;
    selector = ImageSelectorUtils(
      height: 480,
      width: 960,
      quality: 50,
      cameraListener: (file) => setState(() => _selectedPicture = file),
      galleryListener: (file) => setState(() => _selectedPicture = file),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text('Nuevo recuerdo')),
      floatingActionButton: uploadButton(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: widget._key,
            child: Column(
              children: [
                ImageAvatar(
                  image: _selectedPicture,
                  icon: Icons.add_a_photo,
                  theme: Palette.primary,
                  themeAlt: Colors.black54,
                  selector: (context) => selector.showSelector(context),
                ),
                SizedBox(height: 20),
                TextFieldEmpty(
                  hint: 'Título *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _title = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    if (_selectedPicture == null) {
      Printer.snackBar(widget._scaffoldKey, Messages.NO_IMAGE);

      return;
    }

    if (widget._key.currentState.validate()) {
      setState(() => _working = true);
      String date = DateTime.now().toString().substring(0, 10);
      String fileName = 'memory_' + _title + '_' + date;

      FirebaseStorageHelper(
        imageToUpload: _selectedPicture,
        fileName: fileName,
        location: 'memories/',
        onSuccess: (url) => saveMemory(url, date),
        onFailure: (_) => showErrorMessage(),
      ).uploadFile();
    }
  }

  void saveMemory(String url, String date) {
    MemoriesDataService service = MemoriesDataService('');

    if (url != null && url.isNotEmpty) {
      final Memory memory = Memory(0, _title, url, date);
      service.post(memory).then(
          (success) => {if (success) showDoneDialog() else showErrorMessage()});
    } else {
      showErrorMessage();
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Su recuerdo ha sido publicado.'),
    ).then((_) => Navigator.of(context).pop());
  }

  void showErrorMessage() {
    setState(() => _working = false);

    Printer.snackBar(widget._scaffoldKey, Messages.ERROR);
  }

  Widget uploadButton() {
    if (_working) {
      return FloatingActionButton(
        onPressed: () => {},
        child: Padding(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: () => _validateForm(),
      child: Icon(Icons.save),
    );
  }
}
