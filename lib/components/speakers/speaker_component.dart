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
  String company = "";
  String photoUrl;
  String country = "";
  String bio = "";

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
        if (snapshot.value != null) {
          setState(() {
            name = snapshot.value['name'];
            photoUrl = "https://hoverboard-demo.firebaseapp.com" +
                snapshot.value['photoUrl'];
            company = snapshot.value['company'];
            country = snapshot.value['country'];
            bio = snapshot.value['bio'];
            print(photoUrl);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              constraints: new BoxConstraints(
                minWidth: double.INFINITY,
              ),
              child: new Hero(
                tag: 'hero-' + name,
                child: new Image.network(
                  photoUrl,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
            new Container(
              padding: new EdgeInsets.all(16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(name, style: Theme.of(context).textTheme.headline),
                  new Text(company, style: Theme.of(context).textTheme.subhead),
                  new Text(country, style: Theme.of(context).textTheme.subhead),
                  new Text(bio, style: Theme.of(context).textTheme.body1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
