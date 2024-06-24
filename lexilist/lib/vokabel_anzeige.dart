import 'package:flutter/material.dart';

import 'package:LexiList/vokabel_liste_page.dart';

class VokabelAnzeige extends StatelessWidget {
  final VokabelListePage genaueliste;
  final String listenname;
  final int index;
  final Function deleteCallback;
  final Function saveCallback;

  VokabelAnzeige({
    Key? key,
    required this.saveCallback,
    required this.genaueliste,
    required this.listenname,
    required this.index,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(listenname),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => deleteCallback(index),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => genaueliste,
            ),
          );
        },
      ),
    );
  }
  
}
