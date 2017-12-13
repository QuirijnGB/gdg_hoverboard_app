import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpeakerPage extends StatefulWidget {
  SpeakerPage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _SpeakerPagePageState createState() => new _SpeakerPagePageState();
}

class _SpeakerPagePageState extends State<SpeakerPage> {
  String _id;
  DataSnapshot snapshot;
  String name = "";

  @override
  void initState() {
    _id = widget.id;

    FirebaseDatabase.instance.reference().child('speakers').child(_id).onValue.listen(
      (event) {
        snapshot = event.snapshot;
        print(snapshot);
        name = snapshot.value['name'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Text(
          name,
          style: new TextStyle(color: Colors.black, fontSize: 20.0),
        ),
      ],
    );
  }
}
