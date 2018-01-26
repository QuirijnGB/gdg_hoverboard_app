import 'package:rxdart/rxdart.dart';

import 'data/schedule_day.dart';
import 'data/session.dart';
import 'schedule_service.dart';

class ScheduleController {
  final ScheduleService _service;

  ScheduleController(this._service);

  Observable<List<ScheduleDay>> getSchedule() {
    print("ScheduleController - getSchedules()");
    return _service.fetchSchedule().map((List list) {
      print("ScheduleController - map() - results $list");
      return list.map((map) => new ScheduleDay(map)).toList();
    });
  }

  Observable<List<Session>> getSessions() {
    print("ScheduleController - getSessions()");
    return _service.fetchSessions().map((list) {
      print("ScheduleController - map() - results $list");
      List<Session> lol = [];
      list.forEach((k, v) {
        lol.add(new Session(v));
      });
      return lol;
    });
  }
}
