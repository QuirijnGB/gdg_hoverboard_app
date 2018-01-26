import 'package:flutter/material.dart';

import 'domain/schedule_controller.dart';
import 'domain/schedule_service.dart';
import 'domain/data/session.dart';

class SessionPage extends StatefulWidget {
  SessionPage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _SessionPagePageState createState() => new _SessionPagePageState();
}

class _SessionPagePageState extends State<SessionPage> {
  final ScheduleController _controller =
      new ScheduleController(new FirebaseScheduleService());

  int _id;
  Session _session;

  @override
  void initState() {
    super.initState();
    _id = int.parse(widget.id);
    _controller.getSession(_id).listen((speaker) {
      setState(() => this._session = speaker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_session.title),
      ),
    );
  }
}
