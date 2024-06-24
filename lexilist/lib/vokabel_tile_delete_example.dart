//class VokabelTileDeleteExample

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class VokabelTileDeleteExample extends StatefulWidget {
  final String deleteExampleName;
  final String dUebersetzung;
  //final String deleteExampleInfos;
  bool ausgewaehlt;

  VokabelTileDeleteExample({
    required this.deleteExampleName,
    required this.dUebersetzung,
    //required this.deleteExampleInfos,
    this.ausgewaehlt = false,
  });

  String nameGeben() {
    return deleteExampleName;
  }

  String uebersetzungGeben() {
    return dUebersetzung;
  }

  @override
  VokabelTileDeleteExampleState createState() =>
      VokabelTileDeleteExampleState();
}

class VokabelTileDeleteExampleState extends State<VokabelTileDeleteExample> {
  Color c = Colors.white;
//hier waren die zwei Farben mit denen unten Schabernack getrieben wurde

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.ausgewaehlt
                ? Color.fromARGB(96, 10, 250, 238) // Blaugrau
                : null, 
      child: ListTile(
        
        trailing: Checkbox(
          activeColor:Color.fromARGB(255, 0, 255, 242) ,
          value: widget.ausgewaehlt,
          onChanged: (value) {
            setState(() {
              widget.ausgewaehlt = value!;
            });
          },
        ),
        title: Text(widget.deleteExampleName,style: TextStyle(
          decoration: widget.ausgewaehlt ? TextDecoration.lineThrough : null,
        ),),
        //geht bestimmt noch besser
        subtitle: Text('Übersetzung:' + widget.dUebersetzung,style: TextStyle(
          decoration: widget.ausgewaehlt ? TextDecoration.lineThrough : null,
        ),),
      ),
    );
  }
}
