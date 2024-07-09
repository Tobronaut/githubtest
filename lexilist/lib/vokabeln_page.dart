// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LexiList/vokabel_anzeige.dart';
import 'package:LexiList/vokabel_liste_page.dart';
import 'package:LexiList/vokabel_tile_example.dart';
import 'package:LexiList/vokabel_trainer.dart';
import 'package:LexiList/vokabel_auswahl.dart';

class Vokabeln extends StatefulWidget {
  @override
  State<Vokabeln> createState() => VokabelnState();
}

class VokabelnState extends State<Vokabeln> {
  List<VokabelListePage> lists = [];
  List<VokabelAnzeige> anzeigen = [];
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
      counter = _prefs.getInt('Vcounter') ?? 0;
    });
  }

  Future<void> _loadEverything() async {
    await _loadCounter();
    setState(() {
      lists.clear();
      anzeigen.clear();
      for (int i = 0; i < counter; i += 1) {
        final List<String>? alles = _prefs.getStringList('V$i');
        final String? name = alles?[0];
        List<VokabelTileExample> teile = [];
        if (alles != null && alles.isNotEmpty) {
          for (int j = 1; j < alles.length; j += 1) {
            teile.add(VokabelTileExample(
              Iteminformationen: alles[j],
              saveCallback: speichern,
              isDeleteMode: false,
            ));
          }
        }
        VokabelListePage neueListe = VokabelListePage(
          einkaufslisteName: name ?? '',
          listTiles: teile,
          saveCallback: speichern,
          deleteCallback: () => showDeleteDialog(i),
          index: i,
        );
        lists.add(neueListe);
        anzeigen.add(VokabelAnzeige(
          saveCallback: speichern,
          index: i,
          genaueliste: lists[i],
          listenname: name ?? "",
          deleteCallback: showDeleteDialog,
        ));
      }
    });
  }

  void _createNewList() {
    createAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: const Text(
          'Vokabeln',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed:() => showQuestionDialog(),


          ),
          IconButton(
            icon: Icon(Icons.school),
            tooltip: 'Alle aktivierten Vokabeln abfragen',
            onPressed: () {
              List<VokabelTileExample> Abzufragen = lists
                  .expand(
                      (list) => list.listTiles.where((tile) => tile.enabled))
                  .toList();
              if (Abzufragen.isNotEmpty) {
                Auswahl auswahl = Auswahl(alleListen: lists);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => auswahl),
                );
              }
            },
          ),
        ],
      ),
      body: ReorderableListView(
        buildDefaultDragHandles: true,
        // Verringerter Abstand zu den Seiten
        children: [
          for (int index = 0; index < anzeigen.length; index++)
            Container(
              key: ValueKey(anzeigen[index]),
              padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0), // Verringerter Abstand zwischen den ListTiles
              child: anzeigen[index],
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = anzeigen.removeAt(oldIndex);
            final list = lists.removeAt(oldIndex);
            anzeigen.insert(newIndex, item);
            lists.insert(newIndex, list);
          });
          speichern();
          _loadEverything();
        },
      ),
      floatingActionButton: Column( 
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        //  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        children:[
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 10, 250, 238),
            tooltip: 'Vokabeltrainer',
            child: Icon(
          Icons.school,
          color: Colors.black,),
        

              onPressed: () {
              List<VokabelTileExample> Abzufragen = lists
                  .expand(
                      (list) => list.listTiles.where((tile) => tile.enabled))
                  .toList();
              if (Abzufragen.isNotEmpty) {
                Auswahl auswahl = Auswahl(alleListen: lists);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => auswahl),
                );
              }
            
            }
          ),
          SizedBox(height: 16),


          FloatingActionButton(
        tooltip: 'Vokabel hinzufügen',
        onPressed: _createNewList,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 10, 250, 238),)
        
      
      ]
        
     
    ));
  }

  Future<void> addListTile(String name, List<VokabelTileExample> liste) async {
    setState(() {
      VokabelListePage neueListe = VokabelListePage(
        einkaufslisteName: name,
        listTiles: liste,
        saveCallback: speichern,
        deleteCallback: () => showDeleteDialog(counter),
        index: counter,
      );
      lists.add(neueListe);
      anzeigen.add(VokabelAnzeige(
        saveCallback: speichern,
        genaueliste: neueListe,
        listenname: name,
        index: counter,
        deleteCallback: showDeleteDialog,
      ));
      counter += 1;
      _prefs.setInt('Vcounter', counter);
    });
    speichern();
  }

  void deleteList(int index) {
    lists.removeAt(index);
    anzeigen.removeAt(index);
    counter -= 1;
    speichern();
    _loadEverything();
  }

  Future<void> speichern() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.setInt('Vcounter', counter);
      for (int i = 0; i < lists.length; i++) {
        VokabelListePage liste = lists[i];
        String einkaufslisteName = liste.einkaufslisteName;
        List<String> listTileNames =
            liste.listTiles.map((tile) => tile.aktuelleInfosgeben()).toList();
        List<String> alles = [einkaufslisteName, ...listTileNames];
        _prefs.setStringList('V$i', alles);
      }
    });
  }

  Future<void> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neue Liste:'),
          content: TextField(
            controller: customController,
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
                List<VokabelTileExample> gebenliste = [];
                addListTile(customController.text.toString(), gebenliste);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
              child: Text('OK'),
              onPressed: () {
                deleteList(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  Future<void> showQuestionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tutorial'),
          content: Column(mainAxisSize: MainAxisSize.min,children: [
            Text('Tutorial-Text wird noch entworfen')
          ],),
          



          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('OK'),
              onPressed: () {
                
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}



