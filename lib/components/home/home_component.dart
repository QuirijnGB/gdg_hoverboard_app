import 'package:flutter/material.dart';

import '../schedule/schedule.dart';

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GDG DevFest"),
      ),
      body: new SchedulePage(),
      bottomNavigationBar: new BottomNavigationBar(items: [
        new BottomNavigationBarItem(
            icon: new Icon(Icons.schedule), title: new Text("Schedule")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.people), title: new Text("Speakers")),
      ]),
    );
  }
}
