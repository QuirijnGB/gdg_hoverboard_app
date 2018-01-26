import 'package:flutter/material.dart';

import 'domain/data/speaker.dart';
import 'domain/speakers_controller.dart';
import 'domain/speakers_service.dart';

class SpeakerPage extends StatefulWidget {
  SpeakerPage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _SpeakerPagePageState createState() => new _SpeakerPagePageState();
}

class _SpeakerPagePageState extends State<SpeakerPage> {
  final SpeakerController _controller =
      new SpeakerController(new FirebaseSpeakersService());

  int _id;
  Speaker _speaker;

  @override
  void initState() {
    super.initState();
    _id = int.parse(widget.id);
    _controller.getSpeaker(_id).listen((speaker) {
      setState(() => this._speaker = speaker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      slivers: [
        new SliverAppBar(
          flexibleSpace: new FlexibleSpaceBar(
            background: new Hero(
              tag: 'hero-' + _speaker.name,
              child: new Image.network(
                _speaker.photoUrl,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
          ),
          pinned: true,
          // Extruding edge from the sliver appbar, may need to fix expanded height
          expandedHeight: MediaQuery.of(context).size.height / 2.5,
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
                    new Text(_speaker.name,
                        style: Theme.of(context).textTheme.headline),
                    new Text(_speaker.company,
                        style: Theme.of(context).textTheme.subhead),
                    new Text(_speaker.country,
                        style: Theme.of(context).textTheme.subhead),
                    new Text(_speaker.bio,
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
