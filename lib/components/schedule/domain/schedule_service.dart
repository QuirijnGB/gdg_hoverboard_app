import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class ScheduleService {
  Observable<List<Map>> fetchSessions();

  Observable<Map> fetchSchedule(int id);
}

class FirebaseScheduleService implements ScheduleService {
  final scheduleRef = FirebaseDatabase.instance.reference().child('schedule');
  final sessionsRef = FirebaseDatabase.instance.reference().child('sessions');

  @override
  Observable<Map> fetchSchedule(int id) {
    return new Observable(scheduleRef.onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }

  @override
  Observable<List<Map>> fetchSessions() {
    return new Observable(sessionsRef.onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }
}
