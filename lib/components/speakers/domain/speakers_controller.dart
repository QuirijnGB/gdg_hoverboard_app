import 'dart:async';
import 'speakers_service.dart';

class SpeakerController {
  final SpeakersService _service;

  SpeakerController(this._service);

  Future<List<Speaker>> getSpeakers() {
    print("SpeakerController - getSpeakers()");
    return _service.fetchSpeakers();
  }
}

class Speaker {
  int id = -1;
  String name = "";
  String photoUrl = "";
  String country = "";
  List<String> tags = [];

  Speaker(Map map) {
    if(map == null){
      throw new Exception("Nah mate");
    }
    print("Create speaker $map");
    id = map["id"];
    name = map["name"];
    photoUrl = map["photoUrl"];
    country = map["country"];
    tags = map["tags"];
  }

  @override
  String toString() {
    return 'Speaker{id: $id, name: $name, photoUrl: $photoUrl, country: $country, tags: $tags}';
  }
}
