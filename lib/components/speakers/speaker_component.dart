import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpeakerPage extends StatefulWidget {
  @override
  _SpeakerPagePageState createState() => new _SpeakerPagePageState();
}

class _SpeakerPagePageState extends State<SpeakerPage> {
  final reference = FirebaseDatabase.instance.reference().child('speakers');

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(child: new Text("Hello speaker")),
      ],
    );
  }
}
