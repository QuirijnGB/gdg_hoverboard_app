import 'package:flutter/material.dart';

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
          String date = day.dateReadable;
          return new Tab(
            child: new Semantics(
              child: new Text(
                date.toUpperCase(),
              ),
              value: day.key,
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
          new Card(
            child: _createSessions(sessions),
          ),
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

  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(session.title,
                    style: Theme.of(context).textTheme.subhead),
                new Text(session.complexity == null ? "" : session.complexity,
                    style: Theme.of(context).textTheme.body1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
