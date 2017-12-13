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

    FirebaseDatabase.instance
        .reference()
        .child('speakers')
        .child(_id)
        .onValue
        .listen(
      (event) {
        snapshot = event.snapshot;
        name = snapshot.value['name'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Image.network("https://hoverboard-demo.firebaseapp.com" +
              snapshot.value['photoUrl']),
          new Container(
            padding: new EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(snapshot.value['name'],
                    style: Theme.of(context).textTheme.headline),
                new Text(snapshot.value['company'],
                    style: Theme.of(context).textTheme.subhead),
                new Text(snapshot.value['country'],
                    style: Theme.of(context).textTheme.subhead),
                new Text(snapshot.value['bio'],
                    style: Theme.of(context).textTheme.body1),
              ],
            ),
          )
        ],
      ),
    );
  }
}
