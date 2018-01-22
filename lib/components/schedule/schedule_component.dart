import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  final reference = FirebaseDatabase.instance.reference().child('sessions');
  final scheduleReference =
      FirebaseDatabase.instance.reference().child('schedule');

  List<Tab> myTabs = <Tab>[new Tab(text: "")];
  TabController _tabController;
  List _days;

  @override
  void initState() {
    super.initState();
    scheduleReference.onValue.listen((event) {
      _tabController = new TabController(vsync: this, length: myTabs.length);
      _days = event.snapshot.value;
      setState(() {
        myTabs = _days.map((day) {
          String date = day['dateReadable'];
          print("Create tab $date");
          return new Tab(
            child: new Semantics(
              child: new Text(
                date.toUpperCase(),
              ),
              value: day['key'],
            ),
          );
        }).toList();
        _tabController = new TabController(vsync: this, length: myTabs.length);
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
            controller: _tabController,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: myTabs,
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: createPages(),
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

  TimeSlot(Map map) {
    startTime = map["startTime"];
    endTime = map["endTime"];
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

  TimeSlotWidget(this.timeSlot);

  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(timeSlot.startTime,
              style: Theme.of(context).textTheme.title),
          new Card(
            child: new Text("Here comes the session"),
          ),
        ],
      ),
    );
  }
}

class SessionItem extends StatelessWidget {
  SessionItem({this.snapshot, this.animation});

  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(snapshot.value['title'],
                      style: Theme.of(context).textTheme.subhead),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
