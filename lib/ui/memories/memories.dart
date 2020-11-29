import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Memory.dart';
import 'package:saborissimo/data/service/MemoriesDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/utils/utils.dart';

class Memories extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MemoriesState createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  String _token;
  MemoriesDataService _service;
  List<Memory> _memories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.memoriesAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
        actions: [createRefreshButton()],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        backgroundColor: Palette.accent,
        onPressed: () => {},
      ),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MemoriesDataService('');
    _service.get().then((response) => setState(() => _memories = response));
  }

  Widget createRefreshButton() {
    return IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshList(),
    );
  }

  Widget createList() {
    if (_memories == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }
    if (_memories.isEmpty) {
      return Center(
        child: Utils.createNoItemsMessage(
          'No se han publicado nuevas memorias',
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (_, index) => createPictureCard(_memories[index]),
      itemCount: _memories.length,
    );
  }

  Widget createPictureCard(Memory memory) {
    return InkWell(
      onTap: () => {},
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  memory.picture,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                memory.title,
                textAlign: TextAlign.center,
                style: Styles.legend(25),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
