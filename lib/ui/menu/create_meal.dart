import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/messages.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/firebase_storage_helper.dart';
import 'package:saborissimo/utils/image_utils.dart';
import 'package:saborissimo/utils/utils.dart';
import 'package:saborissimo/utils/validation_utils.dart';
import 'package:saborissimo/widgets/body_label.dart';
import 'package:saborissimo/widgets/input/image_avatar.dart';
import 'package:saborissimo/widgets/input/long_text_field_empty.dart';
import 'package:saborissimo/widgets/input/selector_field_empty.dart';
import 'package:saborissimo/widgets/input/text_field_empty.dart';
import 'package:saborissimo/widgets/material_dialog_neutral.dart';

class CreateMeal extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  ImageSelectorUtils selector;
  File _selectedPicture;

  bool _working;
  String _token;
  String _name;
  String _description;
  String _type;

  @override
  void initState() {
    PreferencesUtils.getToken((result) => setState(() => _token = result));

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
      appBar: AppBar(title: Text(Names.createMealAppBar)),
      floatingActionButton: uploadButton(),
      body: Padding(
        padding: EdgeInsets.all(10),
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
                  hint: 'Nombre *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _name = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                SizedBox(height: 10),
                LongTextFieldEmpty(
                  hint: 'Descripción *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _description = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                SizedBox(height: 10),
                SelectorFieldEmpty(
                  options: Names.mealTypeSelector,
                  hint: 'Tipo de platillo *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _type = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                Container(
                  width: double.infinity,
                  child: BodyLabel('* Campos obligatorios'),
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
      Utils.showSnack(widget._scaffoldKey, Messages.NO_IMAGE);

      return;
    }

    if (widget._key.currentState.validate()) {
      setState(() => _working = true);
      String fileName = 'meal_' +
          _type +
          '_' +
          _name +
          '_' +
          DateTime.now().toString().substring(0, 10);

      FirebaseStorageHelper(
        imageToUpload: _selectedPicture,
        fileName: fileName,
        location: 'meals/',
        onSuccess: (url) => saveMeal(url),
        onFailure: (_) => showErrorMessage(),
      ).uploadFile();
    }
  }

  void saveMeal(String url) {
    MealsDataService service = MealsDataService(_token);

    if (url != null && url.isNotEmpty) {
      final Meal meal = Meal(0, _name, _description, url, _type);
      service.post(meal).then(
            (success) =>
                {if (success) showDoneDialog() else showErrorMessage()},
          );
    } else {
      setState(() => _working = false);
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Platillo creado con exito.'),
    ).then((_) => Navigator.of(context).pop());
  }

  void showErrorMessage() {
    setState(() => _working = false);

    Utils.showSnack(widget._scaffoldKey, Messages.ERROR);
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
