import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
    scheduleReference.onValue.listen((event) {
      _tabController = new TabController(vsync: this, length: myTabs.length);
      _days = event.snapshot.value;
      setState(() {
        myTabs = _days.map((day) {
          String date = day['dateReadable'];
          print("Create tab $date");
          return new Tab(
              child: new Semantics(
            child: new Text(date),
            value: day['key'],
          ));
        }).toList();
        _tabController = new TabController(vsync: this, length: myTabs.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          color: Colors.blue,
          child: new TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: myTabs,
          ),
        ),
        new Container(
          height: 200.0,
          child: new TabBarView(
            controller: _tabController,
            children: myTabs.map((Tab tab) {
              var day = _days[_tabController.index]['dateReadable'];
              return new Text(day, style: Theme.of(context).textTheme.body1);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

//        new Flexible(
//          child: new FirebaseAnimatedList(
//            query: reference,
//            sort: (a, b) => b.key.compareTo(a.key),
//            padding: new EdgeInsets.all(8.0),
//            itemBuilder:
//                (_, DataSnapshot snapshot, Animation<double> animation) {
//              return new SessionItem(snapshot: snapshot, animation: animation);
//            },
//          ),
//        ),
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
