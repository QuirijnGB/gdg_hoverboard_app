import 'package:flutter/material.dart';

import '../schedule/schedule_component.dart';
import '../speakers/speakers_component.dart';

class HomeComponent extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
class _MyHomePageState extends State<HomeComponent> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: new MaterialApp(home: new SchedulePage()),
            ),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: new MaterialApp(home: new SpeakersPage()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: index,
          onTap: (int index) {
            setState(() {
              this.index = index;
            });
          },
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.schedule), title: new Text("Schedule")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.people), title: new Text("Speakers")),
          ]),
    );
  }

}