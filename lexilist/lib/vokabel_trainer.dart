import 'package:flutter/material.dart';
import 'package:LexiList/vokabel_tile_example.dart';

class VokabelTrainer extends StatefulWidget {
  final List<VokabelTileExample> listTiles;
  final bool umgekert;

  VokabelTrainer({Key? key, required this.listTiles, required this.umgekert})
      : super(key: key);

  @override
  _VokabelTrainerState createState() => _VokabelTrainerState();
}

class _VokabelTrainerState extends State<VokabelTrainer> {
  late List<VokabelTileExample> _toCheck;
  late VokabelTileExample _currentTile;
  bool umgekert = false;

  @override
  void initState() {
    super.initState();
    _toCheck = List.from(widget.listTiles);
    _currentTile = _toCheck.removeAt(0);
  }

  void _nextTile() async {
    setState(() {
      if (_toCheck.isNotEmpty) {
        _currentTile = _toCheck.removeAt(0);
      } else {
        // Handle the end of the list, e.g., show a message
        _currentTile = new VokabelTileExample(
            Iteminformationen:
                '    Alle Vokabeln abgefragt     *true*    Alle Vokabeln abgefragt     ',
            saveCallback: leereDummimethode,isDeleteMode: false,);
            
      }
    });
  }

  void _dontKnow() {
    setState(() {
      _toCheck.add(_currentTile);
      _nextTile();
    });
  }

  void _checkAnswer(String answer) {
    bool isCorrect = widget.umgekert
        ? answer == _currentTile.Uebersetzung
        : answer == _currentTile.neuItemname;
    if (isCorrect) {
      _nextTile();
    } else {
      setState(() {
        _toCheck.add(_currentTile);
        _nextTile();
      });
    }
    _showFeedbackDialog(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: const Text(
          'Trainingsmodus',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //  actions: [
        //   IconButton(
        //     icon: Icon(Icons.autorenew),
        //     tooltip: 'Alle aktivierten Vokabeln abfragen',
        //     onPressed: () {
        //       // Navigiere zum Vokabeltrainer-Bildschirm

        //     umgekert = !umgekert;
        //       setState(() {

        //       });
        //     },

        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.umgekert
                    ? _currentTile.neuItemname
                    : _currentTile.Uebersetzung,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  color: Colors.green,
                  child: TextButton(
                    onPressed: () {
                      _showAnswerDialog();
                    },
                    child: Text(
                      'Weiß ich',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  color: Colors.red,
                  child: TextButton(
                    onPressed: () {
                      _dontKnow();
                    },
                    child: Text(
                      'Weiß ich nicht',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAnswerDialog() {
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lösung eingeben'),
          content: TextField(
            controller: answerController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Überprüfen'),
              onPressed: () {
                Navigator.of(context).pop();
                _checkAnswer(answerController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 50,
              ),
              SizedBox(width: 10),
              Text(
                isCorrect ? 'Richtig!' : 'Falsch!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(milliseconds: 325), () {
      Navigator.of(context).pop();
      if (_currentTile.Uebersetzung == '    Alle Vokabeln abgefragt     ') {
        Navigator.pop(context);
      }
    });
  }

  void leereDummimethode() {}
}
