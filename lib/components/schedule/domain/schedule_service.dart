import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class ScheduleService {
  Observable<List<Map>> fetchSchedule();

  Observable<Map> fetchSessions();

  Observable<Map> fetchSession(int id);
}

class FirebaseScheduleService implements ScheduleService {
  final scheduleRef = FirebaseDatabase.instance.reference().child('schedule');
  final sessionsRef = FirebaseDatabase.instance.reference().child('sessions');

  @override
  Observable<List<Map>> fetchSchedule() {
    return new Observable(scheduleRef.onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }

  @override
  Observable<Map> fetchSessions() {
    return new Observable(sessionsRef.onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }

  @override
  Observable<Map> fetchSession(int id) {
    return new Observable(sessionsRef
        .child("$id")
        .onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }
}
