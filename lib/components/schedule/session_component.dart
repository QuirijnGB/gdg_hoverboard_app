import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../speakers/domain/speakers_controller.dart';
import '../speakers/domain/speakers_service.dart';
import 'domain/data/session.dart';
import 'domain/schedule_controller.dart';
import 'domain/schedule_service.dart';

class SessionPage extends StatefulWidget {
  SessionPage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _SessionPagePageState createState() => new _SessionPagePageState();
}

class _SessionPagePageState extends State<SessionPage> {
  final ScheduleController _controller =
      new ScheduleController(new FirebaseScheduleService());
  final SpeakerController _speakersController =
      new SpeakerController(new FirebaseSpeakersService());

  int _id;
  Session _session;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _id = int.parse(widget.id);
    print("initState $_id");
    loadSession();
  }

  void loadSession() {
    isLoading = true;
    _controller.getSession(_id).flatMap((session) {
      if (session.speakerIds == null || session.speakerIds.length < 1) {
        return new Observable.just(session);
      }
      return _speakersController
          .getSpeaker(session.speakerIds[0])
          .map((speaker) {
        session.speakers.add(speaker);
        return session;
      });
    }).listen((session) {
      setState(() {
        isLoading = false;
        this._session = session;
        print("setState $session");
      });
    });
  }

  Widget displayLoading(){
    return new CircularProgressIndicator();
  }

  Widget displaySession(){
    return new CustomScrollView(
      slivers: [
        new SliverAppBar(
          flexibleSpace: new FlexibleSpaceBar(
            background: new Hero(
              tag: 'hero-${_session.id}',
              child: new Image.network(
                _session.image,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
          ),
          pinned: true,
          // Extruding edge from the sliver appbar, may need to fix expanded height
          expandedHeight: _session.image.isEmpty
              ? null
              : MediaQuery.of(context).size.height / 2.5,
        ),
        new SliverFillRemaining(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_session.title,
                        style: Theme.of(context).textTheme.headline),
                    new Text(_session.complexity,
                        style: Theme.of(context).textTheme.subhead),
                    new Text(_session.description,
                        style: Theme.of(context).textTheme.subhead),
                    new Text("${_session.speakers[0].name}",
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? displayLoading() : displaySession();
  }
}
