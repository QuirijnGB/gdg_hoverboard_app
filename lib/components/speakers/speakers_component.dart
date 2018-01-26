import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../config/application.dart';
import 'domain/speakers_controller.dart';
import 'domain/speakers_service.dart';
import 'domain/data/speaker.dart';

class SpeakersPage extends StatefulWidget {
  @override
  _SpeakersPagePageState createState() => new _SpeakersPagePageState();
}

class _SpeakersPagePageState extends State<SpeakersPage> {
  final SpeakerController controller =
      new SpeakerController(new FirebaseSpeakersService());
  List<Speaker> speakers = [];

  @override
  void initState() {
    super.initState();
    controller.getSpeakers().listen((speakers) {
      print("Component - getSpeakers()");
      setState(() {
        this.speakers = speakers;
        print("new speakers $speakers");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('GDG DevFest'),
        ),
        body: new Container(
          child: new ListView.builder(
            itemCount: speakers.length,
            itemBuilder: (BuildContext context, int index) {
              return new SpeakerItem(speakers[index]);
            },
          ),
        ));
  }
}

class SpeakerItem extends StatelessWidget {
  SpeakerItem(this.speaker);

  final Speaker speaker;

  GestureTapCallback _goToSpeakerDetails(BuildContext context, int id) {
    return () {
      Application.router.navigateTo(context, "/speakers/$id",
          transition: TransitionType.fadeIn);
    };
  }

  Widget build(BuildContext context) {
    return new InkWell(
      onTap: _goToSpeakerDetails(context, speaker.id),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              constraints: new BoxConstraints(
                minWidth: double.INFINITY,
              ),
              child: new Hero(
                tag: 'hero-' + speaker.name,
                child: new Image.network(
                  "https://hoverboard-demo.firebaseapp.com" + speaker.photoUrl,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
            new ListTile(
              title: new Text(speaker.name),
              subtitle: new Text(speaker.country),
            ),
            new SpeakerSkillsItem(speaker.tags),
          ],
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
