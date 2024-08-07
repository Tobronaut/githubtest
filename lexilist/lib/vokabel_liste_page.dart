
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LexiList/delete_page.dart';
import 'package:LexiList/vokabel_tile_delete_example.dart';
import 'package:LexiList/vokabel_tile_example.dart';

class VokabelListePage extends StatefulWidget {
  final String einkaufslisteName;
 List<VokabelTileExample> listTiles;
  final int index;

  final Function saveCallback;
  final Function deleteCallback;

  VokabelListePage({
    Key? key,
    required this.einkaufslisteName,
    required this.listTiles,
    required this.saveCallback,
    required this.deleteCallback,
    required this.index,
  }) : super(key: key);

  //void resetList (List <VokabelTileExample> neuesListenDing) {
  //this.listTiles=neuesListenDing;
  //}

  @override
  VokabelListePageState createState() => VokabelListePageState();
}

class VokabelListePageState extends State<VokabelListePage> {
  bool isDeleteMode = false;
  bool isDeleteClickedOnce = false;
  

   Future<void> _loadListTiles() async {
    final prefs = await SharedPreferences.getInstance();
    int i = widget.index;
    List<String>? savedListTiles =
        prefs.getStringList('V$i');
    
    if (savedListTiles != null) {
      savedListTiles.removeAt(0);
      setState(() {
        widget.listTiles = savedListTiles.map((tileData) {
          List<String> parts = tileData.split('*');
          return VokabelTileExample(
            // Always start as unselected
            Iteminformationen: tileData ,
            saveCallback: widget.saveCallback,
            
            isDeleteMode: isDeleteMode,
            
          );
        }).toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: Text(
          widget.einkaufslisteName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: BackButton(
          //icon: Icon(Icons.home),
          onPressed: () {
              if (isDeleteMode) {
                _DeleteModeOff();
              } else {
                Navigator.pop(context);
              }
            },
        ),
        actions: [
          isDeleteMode?Center(child:Text('Löschauswahl  ',style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold))):IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _toggleDeleteMode,
            )
        ],
      ),

      //IconButton (in actions)

      body: ReorderableListView(
        // Verringerter Abstand zu den Seiten
        children: [
          for (int index = 0; index < widget.listTiles.length; index++)
            Container(
              key: ValueKey(widget.listTiles[index]),
              padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0), // Verringerter Abstand zwischen den ListTiles
              child: widget.listTiles[index],
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = widget.listTiles.removeAt(oldIndex);
            widget.listTiles.insert(newIndex, item);
          });
          widget.saveCallback();
          
        },
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //SizedBox(height: 16),
          //FloatingActionButton(
          //  tooltip: 'Zurück',
          // onPressed: () {
          //    Navigator.pop(context);
          //  },
          //  child: Icon(Icons.task_alt),
          //  backgroundColor: Colors.blueGrey,
          //),
          SizedBox(height: 16),
          isDeleteMode?FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 10, 250, 238),
            tooltip: 'Löschen',
            onPressed: _toggleDeleteMode,
            child: Icon(
              Icons.delete,
              color: Colors.black,
            ),
          )
          :
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 10, 250, 238),
            tooltip: 'Vokabel hinzufügen',
            onPressed: () {
              createAlertDialog(context);
            },
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
void _toggleDeleteMode() {
    if (isDeleteMode && isDeleteClickedOnce) {
      setState(() {
        isDeleteClickedOnce = false; // Reset after showing dialog
      });
      _showDeleteConfirmationDialog();
      
    } else {
      if(widget.listTiles.isNotEmpty){
      setState(() {
        isDeleteMode = !isDeleteMode;
        isDeleteClickedOnce = isDeleteMode; 
        _loadListTiles();// Set true if entering delete mode
        if (isDeleteMode) {
          for (var tile in widget.listTiles) {
            setState(() {
            
            tile.isSelectedForDeletion = false;
            });
            setState(() {
              
            });
            
          }
        }
      });
    }
  }}
  void _DeleteModeOff() {
    if (isDeleteMode) {
      setState(() {
        isDeleteMode = false;
        _loadListTiles();
      });
    }
  }
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Willst du dies wirklich löschen?'),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Abbrechen'),
              onPressed: () {
                setState(() {
                  isDeleteClickedOnce = true;
                });
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text('Ja'),
              onPressed: () {
                _deleteSelectedItems();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
    void _deleteSelectedItems() {
    setState(() {
      widget.listTiles.removeWhere((tile) => tile.isSelectedForDeletion);
      isDeleteMode = false;
      
    });
    widget.saveCallback();
    setState(() {
        _loadListTiles();
      });
  }


  String NameGeben() {
    return widget.einkaufslisteName;
  }

  //int laengeGeben
  int laengeGeben() {
    return widget.listTiles.length;
  }

  //dListeErstellen
  List<VokabelTileDeleteExample> dListeErstellen() {
    List<VokabelTileDeleteExample> leereListe = [];

    for (int i = 0; i < widget.listTiles.length; i++) {
      String aktuellerName = widget.listTiles[i].neuItemname;
      String aktuelleUebersetzung = widget.listTiles[i].Uebersetzung;
      leereListe.add(VokabelTileDeleteExample(
        deleteExampleName: aktuellerName,
        dUebersetzung: aktuelleUebersetzung,
      ));
    }
    return leereListe;
  }

  Future createAlertDialog(BuildContext context) {
    TextEditingController customController1 = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('neue Vokabel:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: customController1,
                decoration: InputDecoration(hintText: 'Fremdsprache:'),
              ),
              TextField(
                controller: customController2,
                decoration: InputDecoration(hintText: 'Übersetzung:'),
              ),
            ],
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
                addListTile(customController1.text.toString(),
                    customController2.text.toString());
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> addListTile(String Uebersetzung, String Fremdsprache) async {
    // Füge das Element hinzu
    widget.listTiles.add(VokabelTileExample(
      Iteminformationen: '$Uebersetzung*true*$Fremdsprache',
      saveCallback: widget.saveCallback,
      isDeleteMode: isDeleteMode,
    ));
    setState(() {});

    // Verzögere die Aktivierung des saveCallback um 300 Millisekunden

    // Aktualisiere das Widget
    widget.saveCallback();

    print('Element hinzugefügt');
  }

  //void deleteListTile
  void deleteListTile(int index) {
    setState(() {
      widget.listTiles.removeAt(index);
    });
    print('Tile gelöscht');
    widget.saveCallback();
  }
}
