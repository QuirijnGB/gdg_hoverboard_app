import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class SpeakersService {
  Observable<List<Map>> fetchSpeakers();
  Observable<Map> fetchSpeaker(int id);
}

class FirebaseSpeakersService implements SpeakersService {
  final speakersRef = FirebaseDatabase.instance.reference().child('speakers');

  @override
  Observable<List<Map>> fetchSpeakers() {
    return new Observable(speakersRef.onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }
  @override
  Observable<Map> fetchSpeaker(int id) {
    return new Observable(speakersRef.child("$id").onValue
        .map((event) => event.snapshot.value)
        .where((map) => map != null));
  }
}
