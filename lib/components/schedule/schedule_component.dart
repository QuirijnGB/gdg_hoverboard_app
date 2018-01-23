import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class MyInheritedWidget extends InheritedWidget {
  final Map sessions;
  final String derp;

  const MyInheritedWidget({Key key, this.sessions, this.derp, child})
      : super(key: key, child: child);

  static MyInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MyInheritedWidget);
  }

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return sessions != old.sessions || derp != old.derp;
  }
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  final reference = FirebaseDatabase.instance.reference().child('sessions');
  final scheduleReference =
      FirebaseDatabase.instance.reference().child('schedule');

  List<Tab> myTabs = <Tab>[const Tab(text: "")];
  List _days;
  Map _sessions;
  String derp;

  @override
  void initState() {
    super.initState();

    loadSessions();

    loadSchedule();
  }

  void loadSchedule() {
    scheduleReference.onValue.listen((event) {
      _days = event.snapshot.value;
      setState(() {
        myTabs = _days.map((day) {
          String date = day['dateReadable'];
          return new Tab(
            child: new Semantics(
              child: new Text(
                date.toUpperCase(),
              ),
              value: day['key'],
            ),
          );
        }).toList();
      });
    });
  }

  void loadSessions() {
    reference.onValue.listen((event) {
      setState(() {
        this._sessions = event.snapshot.value;
        this.derp = "hah";
        print(_sessions);
      });
    });
  }

  List<Widget> createPages() {
    List pages = [];
    myTabs.forEach((Tab tab) {
      var scheduleDay = new ScheduleDay(_days[myTabs.indexOf(tab)]);
      print("create page $scheduleDay");
      pages.add(new DayScheduleWidget(scheduleDay));
    });
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
          derp: derp,
          child: new TabBarView(
            children: createPages(),
          ),
        ),
      ),
    );
  }
}

class ScheduleDay {
  String dateReadable;
  String date;
  List<TimeSlot> timeSlots;
  List<Track> tracks;

  ScheduleDay(Map map) {
    dateReadable = map["dateReadable"];
    date = map["date"];

    timeSlots = TimeSlot.mapTimeSlots(map["timeslots"]);
    tracks = Track.mapTracks(map["tracks"]);
  }

  @override
  String toString() {
    return 'ScheduleDay{dateReadable: $dateReadable, date: $date, timeSlots: $timeSlots, tracks: $tracks}';
  }
}

class TimeSlot {
  String startTime;
  String endTime;
  List sessionIds = [];

  TimeSlot(Map map) {
    startTime = map["startTime"];
    endTime = map["endTime"];
    sessionIds = map["sessions"];
  }

  @override
  String toString() {
    return 'TimeSlot{startTime: $startTime, endTime: $endTime}';
  }

  static List<TimeSlot> mapTimeSlots(List map) {
    List<TimeSlot> timeslots = [];
    if (map != null) {
      map.forEach((v) {
        timeslots.add(new TimeSlot(v));
      });
    }
    return timeslots;
  }
}

class Track {
  String title;

  Track(Map map) {
    title = map["title"];
  }

  static List<Track> mapTracks(List map) {
    List<Track> tracks = [];
    if (map != null) {
      map.forEach((v) {
        tracks.add(new Track(v));
      });
    }
    return tracks;
  }

  @override
  String toString() {
    return 'Track{title: $title}';
  }
}

class Session {
  String title, description, complexity;
  int id;

  Session(Map map) {
    title = map["title"];
    description = map["description"];
    complexity = map["complexity"];
    id = map["id"];
  }

  static List<Session> mapSessions(Map map) {
    List<Session> sessions = [];
    if (map != null) {
      map.forEach((k, v) {
        sessions.add(new Session(v));
      });
    }
    return sessions;
  }

  @override
  String toString() {
    return 'Session{title: $title, description: $description, complexity: $complexity, id: $id}';
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
    List<Session> mapTracks = Session.mapSessions(myInheritedWidget.sessions);
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
    print(sessions);
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
