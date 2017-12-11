import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class SpeakersPage extends StatefulWidget {

  @override
  _SpeakersPagePageState createState() => new _SpeakersPagePageState();
}

class _SpeakersPagePageState extends State<SpeakersPage> {
  final reference = FirebaseDatabase.instance.reference().child('speakers');

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new FirebaseAnimatedList(
            query: reference,
            sort: (a, b) => b.key.compareTo(a.key),
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder:
                (_, DataSnapshot snapshot, Animation<double> animation) {
              return new SpeakerItem(snapshot: snapshot, animation: animation);
            },
          ),
        ),
      ],
    );
  }
}

class SpeakerItem extends StatelessWidget {
  SpeakerItem({this.snapshot, this.animation});

  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.network("https://hoverboard-demo.firebaseapp.com" + snapshot.value['photoUrl']),
            new ListTile(
              title: new Text(snapshot.value['name']),
              subtitle: new Text(snapshot.value['country']),
            ),
          ],
        ),
      )
    );
  }
}

