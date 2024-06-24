// anzeige.dart
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'einkaufs_liste_page.dart';

class Anzeige extends StatelessWidget {
  final EinkaufsListePage genaueliste;
  String Listenname;
  final Function deleteCallback;
  final Function(String) editCallback;
  final bool isDarkModeEnabled;

  Anzeige({
    required this.genaueliste,
    required this.Listenname,
    required this.deleteCallback,
    required this.editCallback,
    required this.isDarkModeEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: ListTile(
        tileColor: const Color.fromARGB(255, 36, 65, 80),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => genaueliste),
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Listenname,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showEditDialog(context);
                  },
                  color: Colors.yellow,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteCallback();
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future showEditDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    FocusNode _focusNode = FocusNode();

    customController.text = Listenname;

    return showDialog(
      context: context,
      builder: (context) {
        return RawKeyboardListener(
          focusNode: _focusNode..requestFocus(),
          onKey: (RawKeyEvent event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              editCallback(customController.text);
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            title: Text('Listenname bearbeiten:'),
            content: TextField(
              controller: customController,
              onSubmitted: (value) {
                editCallback(customController.text);
                Navigator.of(context).pop();
              },
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
                child: Text('Speichern'),
                onPressed: () {
                  editCallback(customController.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
