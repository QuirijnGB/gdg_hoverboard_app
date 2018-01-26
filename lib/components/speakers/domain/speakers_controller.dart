import 'package:rxdart/rxdart.dart';

import 'speakers_service.dart';
import 'data/speaker.dart';

class SpeakerController {
  final SpeakersService _service;

  SpeakerController(this._service);

  Observable<List<Speaker>> getSpeakers() {
    print("SpeakerController - getSpeakers()");
    return _service.fetchSpeakers().map((list) {
      print("SpeakerController - map() - results $list");
      return list
          .where((map) => map != null)
          .map((map) => new Speaker(map))
          .toList();
    });
  }
}
