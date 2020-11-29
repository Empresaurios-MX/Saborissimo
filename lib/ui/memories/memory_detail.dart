import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Memory.dart';
import 'package:saborissimo/data/service/MemoriesDataService.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class MemoryDetail extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Memory memory;

  MemoryDetail(this.memory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(memory.title, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete_forever),
        backgroundColor: Palette.accent,
        onPressed: () => showDeleteDialog(context),
      ),
      body: Column(
        children: [
          Image.network(
            memory.picture,
            height: 500,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  void deleteMemory(BuildContext context) {
    String token = '';
    MemoriesDataService service;

    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {
            token = preferences.getString(PreferencesUtils.TOKEN_KEY),
            service = MemoriesDataService(token),
            service
                .delete(memory.id.toString())
                .then(
                  (success) => {
                    if (success)
                      Navigator.pop(context)
                    else
                      Utils.showSnack(
                        _scaffoldKey,
                        'Error, inicie sesión e intente de nuevo',
                      )
                  },
                )
                .catchError(
                  (_) => Utils.showSnack(
                    _scaffoldKey,
                    'Error, inicie sesión e intente de nuevo',
                  ),
                )
          }
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          'Borrar memoria, ¿Está de acuerdo?',
          textAlign: TextAlign.center,
          style: Styles.subTitle(Colors.black),
        ),
        content: Icon(
          Icons.warning,
          color: Palette.todo,
          size: 80,
        ),
        actions: [
          FlatButton(
            onPressed: () => {deleteMemory(context), Navigator.pop(context)},
            child: Text("Sí"),
            textColor: Palette.primary,
          ),
          FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text("No"),
            textColor: Palette.primary,
          ),
        ],
      ),
    );
  }
}
