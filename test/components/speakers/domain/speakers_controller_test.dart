import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:gdg_devfest/components/speakers/domain/speakers_service.dart';
import 'package:gdg_devfest/components/speakers/domain/speakers_controller.dart';

class MockSpeakersService extends Mock implements SpeakersService {}

void main() {
  test('SpeakerController - getSpeakers', () {
    var mockSpeakersService = new MockSpeakersService();
    var controller = new SpeakerController(mockSpeakersService);
    controller.getSpeakers();
    verify(mockSpeakersService.fetchSpeakers());
  });
}