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
    return _service.fetchSessions().map((map) {
      print("ScheduleController - map() - results $map");
      List<Session> sessions = [];
      map.forEach((k, v) {
        sessions.add(new Session(v));
      });
      return sessions;
    });
  }

  Observable<Session> getSession(int id) {
    print("ScheduleController - getSessions()");
    return _service.fetchSession(id).map((map) {
      print("ScheduleController - map() - results $map");
      return new Session(map);
    });
  }
}
