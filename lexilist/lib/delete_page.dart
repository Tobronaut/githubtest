//class deletePage
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LexiList/vokabel_liste_page.dart';
import 'package:LexiList/vokabel_tile_delete_example.dart';
import 'package:LexiList/vokabel_tile_example.dart';

class deletePage extends StatefulWidget {
  final VokabelListePage jeneListe;
  final VokabelListePageState jeneListeState;
  final List<VokabelTileDeleteExample> dListTiles;

  deletePage({
    required this.jeneListe,
    required this.jeneListeState,
    required this.dListTiles,
  });

  @override
  deletePageState createState() => deletePageState();
}

class deletePageState extends State<deletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: Text(
          widget.jeneListe.einkaufslisteName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () async {
            Navigator.pop(context);

            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => widget.jeneListe)));
            late SharedPreferences _prefs;
            _prefs = await SharedPreferences.getInstance();
            _prefs.setBool('zweimal', true);
          },
        ),
      ),
      body: ListView(
        children: [
          // Zeige alle vorhandenen ListTiles an
          ...widget.dListTiles,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dDialog();
        },
        backgroundColor: Color.fromARGB(255, 10, 250, 238),
        child: const Icon(Icons.delete),
      ),
    );
  }

  //void selectedLoeschenAlt () {
  //for (int i=0; i<widget.dListTiles.length; i++) {
  //if (widget.dListTiles[i].ausgewaehlt) {
  //widget.jeneListeState.deleteListTile(i);
  //deleteDTile(i);
  //widget.jeneListe.saveCallback;
  //}
  //}
  //}

  void selectedLoeschenNeu() {
    for (int i = widget.dListTiles.length - 1; i > -1; i--) {
      if (widget.dListTiles[i].ausgewaehlt) {
        widget.jeneListeState.deleteListTile(i);
        deleteDTile(i);
      }
    }
  }

  //void selectedLoeschenNeuNeu () {
  //  List<VokabelTileExample> testListe = widget.jeneListe.listTiles;
  //  for (int i=widget.dListTiles.length-1; i>-1; i--) {
  //    if (widget.dListTiles[i].ausgewaehlt) {
  //      testListe.removeAt(i);
  //      deleteDTile(i);
  //    }
  //  }
  //  widget.jeneListe.resetList(testListe);
  //}

  void deleteDTile(int o) {
    setState(() {
      widget.dListTiles.removeAt(o);
    });
  }

  Future dDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Willst du die ausgewählten Vokabeln löschen?'),
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
                selectedLoeschenNeu();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
