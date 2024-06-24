// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_tile_example.dart';

class EinkaufsListePage extends StatefulWidget {
  String einkaufslisteName;
  List<ListTileExample> listTiles;
  final VoidCallback saveCallback;
  final VoidCallback deleteCallback;
  final Function(String) editCallback;
  int sortState;
  final bool isDarkModeEnabled;

  EinkaufsListePage({
    Key? key,
    required this.einkaufslisteName,
    required this.listTiles,
    required this.saveCallback,
    required this.deleteCallback,
    required this.editCallback,
    required this.sortState,
    required this.isDarkModeEnabled,
  }) : super(key: key);

  @override
  _EinkaufsListePage createState() => _EinkaufsListePage();

  void sortListTiles(int sortState) {
    if (sortState == 1) {
      listTiles.sort((a, b) => a.neuItemname.compareTo(b.neuItemname));
    } else if (sortState == 2) {
      listTiles.sort((a, b) => b.neuItemname.compareTo(a.neuItemname));
    }
  }
}

class _EinkaufsListePage extends State<EinkaufsListePage> {
  bool isDeleteMode = false;
  bool isDeleteClickedOnce = false;

  @override
  void initState() {
    super.initState();
    _loadSortState();
    _loadListTiles();
  }

  Future<void> _loadSortState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.sortState =
          prefs.getInt('${widget.einkaufslisteName}_sortState') ?? 0;
      sortListTiles();
    });
  }

  Future<void> _loadListTiles() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedListTiles =
        prefs.getStringList(widget.einkaufslisteName);
    if (savedListTiles != null) {
      setState(() {
        widget.listTiles = savedListTiles.map((tileData) {
          List<String> parts = tileData.split('*');
          return ListTileExample(
            neuItemname: parts[0],
            isStarred: parts[1] == 'true',
            isSelectedForDeletion: false, // Always start as unselected
            saveCallback: widget.saveCallback,
            toggleSelection: () {
              _saveListTiles();
            },
            isDeleteMode: isDeleteMode,
            isDarkModeEnabled: widget.isDarkModeEnabled,
          );
        }).toList();
      });
    }
  }

  void sortListTiles() {
    setState(() {
      if (widget.sortState == 1) {
        widget.listTiles.sort((a, b) => a.neuItemname.compareTo(b.neuItemname));
      } else if (widget.sortState == 2) {
        widget.listTiles.sort((a, b) => b.neuItemname.compareTo(a.neuItemname));
      }
      widget.saveCallback();
      _saveSortState();
    });
  }

  Future<void> _saveSortState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        '${widget.einkaufslisteName}_sortState', widget.sortState);
  }

  Future<void> _saveListTiles() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tileData =
        widget.listTiles.map((tile) => tile.aktuelleInfosGeben()).toList();
    await prefs.setStringList(widget.einkaufslisteName, tileData);
  }

  void _toggleDeleteMode() {
    if (isDeleteMode && isDeleteClickedOnce) {
      _showDeleteConfirmationDialog();
      setState(() {
        isDeleteClickedOnce = false; // Reset after showing dialog
      });
    } else {
      setState(() {
        isDeleteMode = !isDeleteMode;
        isDeleteClickedOnce = isDeleteMode; // Set true if entering delete mode
        if (isDeleteMode) {
          for (var tile in widget.listTiles) {
            tile.isSelectedForDeletion = false;
          }
        }
      });
    }
  }

  void _DeleteModeOff() {
    if (isDeleteMode) {
      setState(() {
        isDeleteMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 21, 145, 207),
          title: Text(
            widget.einkaufslisteName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
          ),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              if (isDeleteMode) {
                _DeleteModeOff();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _toggleDeleteMode,
            ),
          ],
        ),
        body: ListView(
          children: _sortedListTiles(),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  widget.sortState = (widget.sortState + 1) % 3;
                  sortListTiles();
                });
              },
              child: Icon(
                Icons.sort,
                color: Colors.black,
              ),
              backgroundColor: Color.fromARGB(255, 10, 250, 238),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                createAlertDialog(context);
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Color.fromARGB(255, 10, 250, 238),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sortedListTiles() {
    List<ListTileExample> sortedTiles = List.from(widget.listTiles);
    if (widget.sortState == 1) {
      sortedTiles.sort((a, b) => a.neuItemname.compareTo(b.neuItemname));
    } else if (widget.sortState == 2) {
      sortedTiles.sort((a, b) => b.neuItemname.compareTo(a.neuItemname));
    }
    return sortedTiles.map((tile) {
      return ListTileExample(
        neuItemname: tile.neuItemname,
        saveCallback: widget.saveCallback,
        isDeleteMode: isDeleteMode,
        isStarred: tile.isStarred,
        isSelectedForDeletion: tile.isSelectedForDeletion,
        toggleSelection: () {
          setState(() {
            if (isDeleteMode) {
              tile.isSelectedForDeletion = !tile.isSelectedForDeletion;
            } else {
              tile.isStarred = !tile.isStarred;
            }
            _saveListTiles();
          });
        },
        isDarkModeEnabled: widget.isDarkModeEnabled,
      );
    }).toList();
  }

  Future createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    FocusNode _focusNode = FocusNode();

    customController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: customController.text.length,
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Listeneintrag:'),
          content: TextField(
            controller: customController,
            focusNode: _focusNode,
            onSubmitted: (value) {
              addListTile(customController.text.toString());
              Navigator.of(context).pop();
            },
            autofocus: true,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Fertig'),
              onPressed: () {
                addListTile(customController.text.toString());
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

  void addListTile(String name) {
    setState(() {
      widget.listTiles.add(ListTileExample(
        neuItemname: name,
        saveCallback: widget.saveCallback,
        isStarred: false,
        isDeleteMode: isDeleteMode,
        toggleSelection: () {
          setState(() {
            _saveListTiles();
          });
        },
        isDarkModeEnabled: widget.isDarkModeEnabled,
      ));
    });
    widget.saveCallback();
    _saveListTiles();
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
    _saveListTiles();
  }
}
