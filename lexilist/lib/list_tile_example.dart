// list_tile_example.dart
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListTileExample extends StatefulWidget {
  String neuItemname;
  final VoidCallback saveCallback;
  bool isStarred;
  bool isSelectedForDeletion;
  final VoidCallback toggleSelection;
  final bool isDeleteMode;
  final bool isDarkModeEnabled;

  ListTileExample({
    Key? key,
    required this.neuItemname,
    required this.saveCallback,
    this.isStarred = false,
    this.isSelectedForDeletion = false,
    required this.toggleSelection,
    required this.isDeleteMode,
    required this.isDarkModeEnabled,
  }) : super(key: key);

  @override
  State<ListTileExample> createState() => _ListTileExampleState();

  String aktuelleInfosGeben() {
    return '$neuItemname*${isStarred.toString()}*${isSelectedForDeletion.toString()}';
  }
}

class _ListTileExampleState extends State<ListTileExample> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.isDeleteMode) {
            widget.isSelectedForDeletion = !widget.isSelectedForDeletion;
          } else {
            widget.isStarred = !widget.isStarred;
          }
          widget.toggleSelection();
        });
      },
      title: Row(
        children: [
          if (widget.isDeleteMode)
            Checkbox(
              value: widget.isSelectedForDeletion,
              onChanged: (value) {
                setState(() {
                  widget.isSelectedForDeletion = value!;
                  widget.toggleSelection();
                });
              },
            )
          else
            Icon(
              Icons.star,
              color: widget.isStarred ? Colors.yellow : Colors.white,
              shadows: [Shadow(blurRadius: 1, color: Colors.black)],
            ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.neuItemname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.isDarkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
      // trailing: IconButton(
      //   icon: Icon(Icons.edit),
      //   onPressed: () {
      //     showEditDialog(context);
      //   },
      // ),
    );
  }

  // Future showEditDialog(BuildContext context) {
  //   TextEditingController customController = TextEditingController();
  //   FocusNode _focusNode = FocusNode();

  //   customController.text = widget.neuItemname;

  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return RawKeyboardListener(
  //         focusNode: _focusNode..requestFocus(),
  //         onKey: (RawKeyEvent event) {
  //           if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
  //             setState(() {
  //               widget.neuItemname = customController.text;
  //               widget.saveCallback();
  //             });
  //             Navigator.of(context).pop();
  //           }
  //         },
  //         child: AlertDialog(
  //           title: Text('Name ändern:'),
  //           content: TextField(
  //             controller: customController,
  //             onSubmitted: (value) {
  //               setState(() {
  //                 widget.neuItemname = customController.text;
  //                 widget.saveCallback();
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           actions: <Widget>[
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('Abbrechen'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('Fertig'),
  //               onPressed: () {
  //                 setState(() {
  //                   widget.neuItemname = customController.text;
  //                   widget.saveCallback();
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
