import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:LexiList/vokabel_liste_page.dart';
import 'package:LexiList/vokabel_tile_example.dart';
import 'package:LexiList/vokabel_trainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auswahl extends StatefulWidget {
  final List<VokabelListePage> alleListen;
  Auswahl({
    required this.alleListen,
  });

  @override
  State<StatefulWidget> createState() => AuswahlpageState();
}

class AuswahlpageState extends State<Auswahl> {
  List<bool> ausgewaehlt = [];
  bool umgekehrt = false;
  bool mixen = false;

  @override
  void initState() {
    super.initState();
    Listefuellen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: Text(
          'Auswahl',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        actions: [
          ElevatedButton(
          
            onPressed: () {
              umgekehrt = !umgekehrt;
              setState(() {});
            },
            
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 21, 145, 207),
              ),
            ),
            child: Text(umgekehrt ? 'dog->Hund' : 'Hund->dog'),
          ),
          IconButton(onPressed: (){mixen = !mixen;setState(() {});print(mixen);}, icon: Icon(Icons.shuffle),
          color: mixen ? Color.fromARGB(255, 10, 250, 238) : null,
          tooltip: 'Vokabeln in zufälliger Reihenfolge abfragen',
          )
            
          
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.alleListen.length,
        itemBuilder: (context, index) {
          return Card(
            color: ausgewaehlt[index]
                ? Color.fromARGB(96, 10, 250, 238) // Blaugrau
                : null, // Hellgrau,
            child:ListTile(
            title: Text(
              widget.alleListen[index].einkaufslisteName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            trailing: Checkbox(
              activeColor:Color.fromARGB(255, 0, 255, 242) ,
              value: ausgewaehlt[index],
              onChanged: (value) {
                setState(() {
                  ausgewaehlt[index] = value!;
                });
              },
            ),
            
          ),
          
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          List<VokabelListePage> selectedLists = widget.alleListen
              .where((list) => ausgewaehlt[widget.alleListen.indexOf(list)])
              .toList();
          List<VokabelTileExample> Abzufragen = selectedLists
              .expand((list) => list.listTiles.where((tile) => tile.enabled))
              .toList();
          if (Abzufragen.isNotEmpty) {
           
            if(mixen == true){Abzufragen.shuffle();}
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VokabelTrainer(
                  umgekert: umgekehrt,
                  listTiles: Abzufragen,
                ),
              ),
            );
          }
        },
        backgroundColor: Color.fromARGB(255, 10, 250, 238),
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> Listefuellen() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? counter = _prefs.getInt('Vcounter');
    if (counter != null) {
      setState(() {
        ausgewaehlt = List.filled(counter, true);
      });
    }
  }
}
