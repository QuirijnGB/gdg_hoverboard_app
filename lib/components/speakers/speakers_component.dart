import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../config/application.dart';

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
            itemBuilder:
                (_, DataSnapshot snapshot, Animation<double> animation) {
              return new SpeakerItem(
                snapshot: snapshot,
                animation: animation,
                context: context,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SpeakerItem extends StatelessWidget {
  SpeakerItem({this.snapshot, this.animation, this.context});

  final DataSnapshot snapshot;
  final Animation animation;
  final BuildContext context;

  GestureTapCallback _getHandler() {
    return () {
      Application.router.navigateTo(context, "/speakers/" + snapshot.key);
    };
  }

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new InkWell(
        onTap: _getHandler(),
        child: new Card(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                constraints: new BoxConstraints(
                  minWidth: double.INFINITY,
                ),
                child: new Hero(
                  tag: 'hero-'+snapshot.value['name'],
                  child: new Image.network(
                    "https://hoverboard-demo.firebaseapp.com" +
                        snapshot.value['photoUrl'],
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              new ListTile(
                title: new Text(snapshot.value['name']),
                subtitle: new Text(snapshot.value['country']),
              ),
              new SpeakerSkillsItem(snapshot.value['tags']),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeakerSkillsItem extends StatelessWidget {
  SpeakerSkillsItem(this.skill);

  final List skill;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (String tag in skill) {
      widgets.add(new SpeakerSkillItem(tag));
    }
    return new Container(
      margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
      child: new Row(
        children: widgets,
      ),
    );
  }
}

class SpeakerSkillItem extends StatelessWidget {
  SpeakerSkillItem(this.skill);

  final String skill;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.red,
        border: new Border.all(width: 1.0, color: Colors.red),
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
      ),
      padding: new EdgeInsets.all(4.0),
      margin: new EdgeInsets.all(4.0),
      child: new Text(
        skill,
        style: new TextStyle(color: Colors.white, fontSize: 10.0),
      ),
    );
  }
}
