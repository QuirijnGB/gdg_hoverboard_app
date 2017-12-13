import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpeakerPage extends StatefulWidget {
  SpeakerPage({Key key, this.id}) : super(key: key);
  final int id;

  @override
  _SpeakerPagePageState createState() => new _SpeakerPagePageState();
}

class _SpeakerPagePageState extends State<SpeakerPage> {
  int _id;
  DataSnapshot snapshot;
  String name = "";

  @override
  void initState() {
    _id = 1;

    FirebaseDatabase.instance
        .reference()
        .child('speakers')
        .onChildAdded
        .first
        .then((event) {
      snapshot = event.snapshot;
      name = snapshot.value['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Text(name);
  }
}
