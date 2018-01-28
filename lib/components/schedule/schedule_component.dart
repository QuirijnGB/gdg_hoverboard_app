import 'package:flutter/material.dart';

import '../../config/application.dart';
import 'domain/data/schedule_day.dart';
import 'domain/data/session.dart';
import 'domain/data/time_slot.dart';
import 'domain/schedule_controller.dart';
import 'domain/schedule_service.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class MyInheritedWidget extends InheritedWidget {
  final List<Session> sessions;

  const MyInheritedWidget({Key key, this.sessions, child})
      : super(key: key, child: child);

  static MyInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MyInheritedWidget);
  }

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return sessions != old.sessions;
  }
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  final _controller = new ScheduleController(new FirebaseScheduleService());

  List<Tab> myTabs = <Tab>[const Tab(text: "")];
  List<ScheduleDay> _days = [];
  List<Session> _sessions = [];

  @override
  void initState() {
    super.initState();

    loadSessions();
    loadSchedule();
  }

  void loadSchedule() {
    _controller.getSchedule().listen((schedule) {
      this._days = schedule;

      setState(() {
        myTabs = _days.map((day) {
          return new Tab(
            child: new Semantics(
              child: new Text(
                day.dateReadable.toUpperCase(),
              ),
              value: day.date,
            ),
          );
        }).toList();
      });
    });
  }

  void loadSessions() {
    _controller
        .getSessions()
        .listen((sessions) => setState(() => this._sessions = sessions));
  }

  List<Widget> createPages() {
    List pages = [];
    if (_days.length > 0) {
      myTabs.forEach((Tab tab) {
        pages.add(new DayScheduleWidget(_days[myTabs.indexOf(tab)]));
      });
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('GDG DevFest'),
          automaticallyImplyLeading: false,
          bottom: new TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: myTabs,
          ),
        ),
        body: new MyInheritedWidget(
          sessions: _sessions,
          child: new TabBarView(
            children: createPages(),
          ),
        ),
      ),
    );
  }
}

class DayScheduleWidget extends StatelessWidget {
  final ScheduleDay schedule;

  DayScheduleWidget(this.schedule);

  Widget build(BuildContext context) {
    return new Container(
      child: new ListView.builder(
        itemCount: schedule.timeSlots.length,
        itemBuilder: (BuildContext context, int index) {
          return new TimeSlotWidget(schedule.timeSlots[index]);
        },
      ),
    );
  }
}

class TimeSlotWidget extends StatelessWidget {
  final TimeSlot timeSlot;

  const TimeSlotWidget(this.timeSlot);

  Widget build(BuildContext context) {
    final myInheritedWidget = MyInheritedWidget.of(context);
    List<Session> sessions = [];
    List<Session> mapTracks = myInheritedWidget.sessions;
    timeSlot.sessionIds.forEach((id) {
      mapTracks.forEach((e) {
        id.forEach((i) {
          if (e.id == i) {
            sessions.add(e);
          }
        });
      });
    });
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Text(timeSlot.startTime,
                style: Theme.of(context).textTheme.title),
          ),
          _createSessions(sessions),
        ],
      ),
    );
  }

  Widget _createSessions(List<Session> sessions) {
    List sessionWidgets = [];
    sessions
        .forEach((sessionId) => sessionWidgets.add(new SessionItem(sessionId)));

    return new Column(
      children: sessionWidgets,
    );
  }
}

class SessionItem extends StatelessWidget {
  final Session session;

  const SessionItem(this.session);

  GestureTapCallback _goToSpeakerDetails(BuildContext context, int id) {
    return () {
      Application.router.navigateTo(context, "/sessions/$id");
    };
  }

  Widget createContent(BuildContext context) {
    return new Container(
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                session.image.isEmpty
                    ? new Container()
                    : new Image.network(session.image),
                new Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(session.title,
                          style: Theme.of(context).textTheme.subhead),
                      new Text(
                          session.complexity == null ? "" : session.complexity,
                          style: Theme.of(context).textTheme.body1),
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

  bool _hasDetails(Session session) {
    //TODO this could be better

    if (session.complexity == null) {
      return false;
    }

    return true;
  }

  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: _hasDetails(session)
            ? _goToSpeakerDetails(context, session.id)
            : null,
        child: createContent(context),
      ),
    );
  }
}
