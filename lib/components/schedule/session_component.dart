import 'package:flutter/material.dart';

import '../speakers/domain/data/speaker.dart';
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
  Session _session = new Session({});
  List<Speaker> _speakers = [];
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
    _controller.getSession(_id).listen((session) {
      setState(() {
        isLoading = false;
        this._session = session;
        loadSpeakers();
      });
    });
  }

  void loadSpeakers() {
    _speakersController
        .getSpeakersById(this._session.speakerIds)
        .listen((speakers) {
      setState(() => _speakers = speakers);
    });
  }

  Widget displayLoading() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget displaySpeakers(List<Speaker> speakers) {
    if (speakers == null || speakers.length < 1) {
      return new Container();
    }
    return new Column(
      children: speakers.map((speaker) => new SpeakerSummary(speaker)).toList(),
    );
  }

  Widget displayTags(List<String> tags) {
    if (tags == null || tags.length < 1) {
      return new Container();
    }
    return new Container(
      padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: new Row(
        children: tags
            .map((tag) =>
                new Text(tag, style: Theme.of(context).textTheme.caption))
            .toList(),
      ),
    );
  }

  Widget displaySession() {
    return new Container(
      color: Colors.white,
      child: new CustomScrollView(
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
                      new Text("${_session.language} | ${_session.complexity}",
                          style: Theme.of(context).textTheme.subhead),
                      displayTags(_session.tags),
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new Text(_session.description,
                            style: Theme.of(context).textTheme.subhead),
                      ),
                      displaySpeakers(_speakers),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? displayLoading() : displaySession();
  }
}

class SpeakerSummary extends StatelessWidget {
  final Speaker speaker;

  const SpeakerSummary(this.speaker);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            backgroundImage: new NetworkImage(speaker.photoUrl),
          ),
          new Container(
            padding: new EdgeInsets.only(left: 8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("${speaker.name}",
                    style: Theme.of(context).textTheme.subhead),
                new Text("${speaker.company}, ${speaker.country}",
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
