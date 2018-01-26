import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:gdg_devfest/components/speakers/domain/speakers_service.dart';
import 'package:gdg_devfest/components/speakers/domain/speakers_controller.dart';

class MockSpeakersService extends Mock implements SpeakersService {}

void main() {
  test('SpeakerController - getSpeakers', () {
    var mockSpeakersService = new MockSpeakersService();
    when(mockSpeakersService.fetchSpeakers())
        .thenAnswer((_) => new Observable.fromIterable([
              [mockSpeaker()]
            ]));
    var controller = new SpeakerController(mockSpeakersService);

    controller.getSpeakers().listen((result) {
      expect(result[0].id, 1);
      expect(result[0].name, "Mete Atamel");
      expect(result[0].country, "London, United Kingdom");
      expect(result[0].photoUrl, "https://hoverboard-demo.firebaseapp.com/images/people/mete_atamel.jpg");
      expect(result[0].tags, ["Cloud", "Compute Engine", "gRPC"]);
    });

    verify(mockSpeakersService.fetchSpeakers());
  });

  test('SpeakerController - getSpeaker', () {
    var mockSpeakersService = new MockSpeakersService();
    when(mockSpeakersService.fetchSpeaker(1))
        .thenAnswer((_) => new Observable.fromIterable([mockSpeaker()]));
    var controller = new SpeakerController(mockSpeakersService);

    controller.getSpeaker(1).listen((result) {
      expect(result.id, 1);
      expect(result.name, "Mete Atamel");
      expect(result.country, "London, United Kingdom");
      expect(result.photoUrl, "https://hoverboard-demo.firebaseapp.com/images/people/mete_atamel.jpg");
      expect(result.tags, ["Cloud", "Compute Engine", "gRPC"]);
    });

    verify(mockSpeakersService.fetchSpeaker(1));
  });
}

Map mockSpeaker() {
  return {
    "bio":
        "Mete is a Developer Advocate at Google, currently focused on helping developers with Google Cloud Platform. As a long-time Java and a recent C# developer, he likes to compare the two ecosystems. Prior to Google, he worked at Microsoft, Skype, Adobe, EMC, and Nokia building apps and services on various web, mobile and cloud platforms. Originally from Cyprus, he currently lives in Greenwich, not too far away from the prime meridian.",
    "company": "Google",
    "companyLogo": "/images/logos/gdg-lviv.svg",
    "country": "London, United Kingdom",
    "featured": true,
    "id": 1,
    "name": "Mete Atamel",
    "photoUrl": "/images/people/mete_atamel.jpg",
    "shortBio":
        "Mete is a Developer Advocate at Google, currently focused on helping developers with Google Cloud...",
    "socials": [
      {
        "icon": "linkedin",
        "link": "https://www.linkedin.com/in/meteatamel/",
        "name": "LinkedIn"
      },
      {
        "icon": "twitter",
        "link": "https://twitter.com/meteatamel/",
        "name": "Twitter"
      },
      {
        "icon": "github",
        "link": "https://github.com/meteatamel/",
        "name": "GitHub"
      }
    ],
    "tags": ["Cloud", "Compute Engine", "gRPC"],
    "title": "Developer Advocate"
  };
}
