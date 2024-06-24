import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_tile_example.dart';
import 'einkaufs_liste_page.dart';
import 'anzeige.dart';

class ListenPage extends StatefulWidget {
  final bool isDarkModeEnabled;

  ListenPage({required this.isDarkModeEnabled});

  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<EinkaufsListePage> lists = [];
  List<Anzeige> anzeigen = [];

  late SharedPreferences _prefs;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = _prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _loadEverything() async {
    await _loadCounter();
    lists.clear();
    anzeigen.clear();
    setState(() {
      for (int i = 0; i < counter; i++) {
        final List<String>? alles = _prefs.getStringList('$i');
        final String? name = alles?[0];
        List<ListTileExample> teile = [];
        if (alles != null && alles.isNotEmpty) {
          for (int j = 1; j < alles.length; j++) {
            List<String> parts = alles[j].split('*');
            teile.add(ListTileExample(
              neuItemname: parts[0],
              isStarred: parts[1] == 'true',
              isSelectedForDeletion: false,
              saveCallback: speichern,
              toggleSelection: () {
                speichern();
              },
              isDeleteMode: false,
              isDarkModeEnabled: widget.isDarkModeEnabled,
            ));
          }
        }

        EinkaufsListePage neueListe = EinkaufsListePage(
          einkaufslisteName: name ?? '',
          listTiles: teile,
          saveCallback: speichern,
          deleteCallback: () => showDeleteDialog(i),
          editCallback: (newName) => editListName(i, newName),
          sortState: 0,
          isDarkModeEnabled: widget.isDarkModeEnabled,
        );
        lists.add(neueListe);

        anzeigen.add(Anzeige(
          genaueliste: lists[i],
          Listenname: name ?? "",
          deleteCallback: () => showDeleteDialog(i),
          editCallback: (newName) => editListName(i, newName),
          isDarkModeEnabled: widget.isDarkModeEnabled,
        ));
      }
    });
  }

  void addListTile(String name, List<ListTileExample> liste) async {
    _prefs = await SharedPreferences.getInstance();
    EinkaufsListePage neueListe = EinkaufsListePage(
      einkaufslisteName: name,
      listTiles: liste,
      saveCallback: speichern,
      deleteCallback: () => showDeleteDialog(counter),
      editCallback: (newName) => editListName(counter, newName),
      sortState: 0,
      isDarkModeEnabled: widget.isDarkModeEnabled,
    );

    setState(() {
      lists.add(neueListe);
      anzeigen.add(Anzeige(
        genaueliste: neueListe,
        Listenname: name,
        deleteCallback: () => showDeleteDialog(counter),
        editCallback: (newName) => editListName(counter, newName),
        isDarkModeEnabled: widget.isDarkModeEnabled,
      ));
      counter += 1;
      _prefs.setInt('counter', counter);
    });
    speichern();
  }

  void addListTileExampleToList(int index, String itemName) async {
    setState(() {
      lists[index].listTiles.add(ListTileExample(
            neuItemname: itemName,
            saveCallback: speichern,
            toggleSelection: () {},
            isDeleteMode: false,
            isDarkModeEnabled: widget.isDarkModeEnabled,
          ));
    });
    speichern();
  }

  void deleteList(int index) {
    setState(() {
      lists.removeAt(index);
      anzeigen.removeAt(index);
      counter -= 1;
      _prefs.setInt('counter', counter);
    });
    speichern();
  }

  void editListName(int index, String newName) {
    setState(() {
      lists[index].einkaufslisteName = newName;
      anzeigen[index].Listenname = newName;
      speichern();
    });
  }

  void speichern() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.setInt('counter', counter);
      for (int i = 0; i < lists.length; i++) {
        final EinkaufsListePage liste = lists[i];
        final String einkaufslisteName = liste.einkaufslisteName;
        final List<String> listTileNames =
            liste.listTiles.map((tile) => tile.aktuelleInfosGeben()).toList();
        final List<String> alles = [einkaufslisteName, ...listTileNames];
        _prefs.setStringList('$i', alles);
      }
    });
    await (_loadEverything());
  }

  Future createAlertDialog(BuildContext context, int? listIndex) {
    TextEditingController customController = TextEditingController();
    FocusNode _focusNode = FocusNode();

    if (listIndex != null && listIndex < lists.length) {
      customController.text = lists[listIndex].einkaufslisteName;
    }
    customController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: customController.text.length,
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Listenname:'),
          content: TextField(
            controller: customController,
            focusNode: _focusNode,
            onSubmitted: (value) {
              if (listIndex == null) {
                List<ListTileExample> gebenliste = [];
                addListTile(customController.text, gebenliste);
              } else {
                addListTileExampleToList(listIndex, customController.text);
              }
              Navigator.of(context).pop();
            },
            autofocus: true,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Fertig'),
              onPressed: () {
                if (listIndex == null) {
                  List<ListTileExample> gebenliste = [];
                  addListTile(customController.text, gebenliste);
                } else {
                  addListTileExampleToList(listIndex, customController.text);
                }
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    ).then((_) {
      _focusNode.requestFocus();
      customController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: customController.text.length,
      );
    });
  }

  Future showDeleteDialog(int index) {
    FocusNode _focusNode = FocusNode();

    return showDialog(
      context: context,
      builder: (context) {
        return RawKeyboardListener(
          focusNode: _focusNode..requestFocus(),
          onKey: (RawKeyEvent event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              deleteList(index);
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            title: Text('Willst du diese Liste wirklich löschen?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text('Ja'),
                onPressed: () {
                  deleteList(index);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future showEditDialog(int index) {
    TextEditingController customController = TextEditingController();
    FocusNode _focusNode = FocusNode();

    customController.text = lists[index].einkaufslisteName;
    customController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: customController.text.length,
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Listenname bearbeiten:'),
          content: TextField(
            controller: customController,
            focusNode: _focusNode,
            onSubmitted: (value) {
              editListName(index, customController.text);
              Navigator.of(context).pop();
            },
            autofocus: true,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text('Fertig'),
              onPressed: () {
                editListName(index, customController.text);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    ).then((_) {
      _focusNode.requestFocus();
      customController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: customController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: const Text(
          'Listen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ...anzeigen,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAlertDialog(context, null);
          setState(() {
            this;
          });
        },
        backgroundColor: Color.fromARGB(255, 10, 250, 238),
        tooltip: 'Liste hinzufügen',
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
