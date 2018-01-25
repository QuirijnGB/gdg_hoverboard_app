import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'speakers_controller.dart';

abstract class SpeakersService {
  Future<List<Speaker>> fetchSpeakers();
}

class FirebaseSpeakersService implements SpeakersService {
  final speakersRef = FirebaseDatabase.instance.reference().child('speakers');

  @override
  Future<List<Speaker>> fetchSpeakers() async {
    return await speakersRef.once().then((snapshot) {
      List speakers = snapshot.value;
      return speakers.where((map) => map != null).map((map) {
        print("SpeakerController - map() - results $map");
        return new Speaker(map);
      }).toList();
    });
  }
}
