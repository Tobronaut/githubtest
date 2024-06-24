// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class VokabelTileExample extends StatefulWidget {
  final String Iteminformationen;
  final Function saveCallback;

  const VokabelTileExample(
      {Key? key, required this.Iteminformationen, required this.saveCallback})
      : super(key: key);

  @override
  State<VokabelTileExample> createState() =>
      _VokabelTileExampleState(Informationen: Iteminformationen);

  String get neuItemname =>
      _VokabelTileExampleState(Informationen: Iteminformationen).neuItemname;
  String aktuelleInfosgeben() {
    return _VokabelTileExampleState(Informationen: Iteminformationen)
        .aktuelleInfos();
  }

  String get aktuelleInfos =>
      _VokabelTileExampleState(Informationen: Iteminformationen)
          .aktuelleInfos();
  bool get enabled =>
      _VokabelTileExampleState(Informationen: Iteminformationen)._enabled;
  String get Uebersetzung =>
      _VokabelTileExampleState(Informationen: Iteminformationen).Uebersetzung;
  set aktuelleInfos(String Infos) {
    aktuelleInfos = Infos;
  }
}

class _VokabelTileExampleState extends State<VokabelTileExample> {
  _VokabelTileExampleState({required this.Informationen});

  bool _selected = true;
  late bool _enabled = isEnabled();
  late String neuItemname = Informationsverwaltung(0);
  late String Uebersetzung = Informationsverwaltung(2);
  late String Informationen;

  String Informationsverwaltung(int index) {
    List<String> parts = Informationen.split('*');
    return parts[index];
  }

  void Informationsaenderung(int index, String Aenderung) {
    List<String> parts = Informationen.split('*');
    parts[index] = Aenderung;
    Informationen = parts.join('*');
  }

  bool isEnabled() {
    String enabledString = Informationsverwaltung(1);
    return enabledString != 'false';
  }

  void EnabledAendern(bool wert) {
    print('Iteminformationenübergeben');
    String Senabled = 'true';
    if (wert == false) {
      Senabled = 'false';
    }
    Informationsaenderung(1, Senabled);
    setState(() {});
  }

  String aktuelleInfos() {
    return '$neuItemname*$_enabled*$Uebersetzung';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(neuItemname),
        subtitle: Text('Übersetzung: $Uebersetzung'),
        //subtitle: Text('Enabled: $_enabled, Selected: $_selected,'),
      ),
    );
  }
}
