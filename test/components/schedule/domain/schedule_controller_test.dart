import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:gdg_devfest/components/schedule/domain/schedule_service.dart';
import 'package:gdg_devfest/components/schedule/domain/schedule_controller.dart';

class MockScheduleService extends Mock implements ScheduleService {}

void main() {
  test('ScheduleController - getSchedule', () {
    var mockScheduleService = new MockScheduleService();
    when(mockScheduleService.fetchSchedule())
        .thenAnswer((_) => new Observable.fromIterable([
              [mockSchedule()]
            ]));
    var controller = new ScheduleController(mockScheduleService);

    controller.getSchedule().listen((result) {
      expect(result.length, 1);
      expect(result[0].dateReadable, "September 9");
      expect(result[0].date, "2016-09-09");
      expect(result[0].tracks[0].title, "Expo hall");
      expect(result[0].timeSlots[0].startTime, "09:00");
      expect(result[0].timeSlots[0].endTime, "10:00");
      expect(result[0].timeSlots[0].sessionIds[0], [132]);
    });

    verify(mockScheduleService.fetchSchedule());
  });

  test('ScheduleController - getSession', () {
    var mockScheduleService = new MockScheduleService();
    when(mockScheduleService.fetchSessions())
        .thenAnswer((_) => new Observable.fromIterable([
              mockSession()
            ]));
    var controller = new ScheduleController(mockScheduleService);

    controller.getSessions().listen((sessions) {
      expect(sessions.length, 1);
      expect(sessions[0].id, 101);
      expect(sessions[0].title, "Windows and .NET on Google Cloud Platform");
      expect(sessions[0].description, "In this session, we will take a look at Windows and .NET support on Google Cloud Platform. We will build a simple ASP.NET app, deploy to Google Compute Engine and take a look at some of the tools and APIs available to .NET developers on Google Cloud Platform.");
      expect(sessions[0].complexity, "Beginner");
    });

    verify(mockScheduleService.fetchSessions());
  });
}

Map mockSchedule() {
  return {
    "date": "2016-09-09",
    "dateReadable": "September 9",
    "timeslots": [
      {
        "endTime": "10:00",
        "sessions": [
          [132]
        ],
        "startTime": "09:00"
      },
      {
        "endTime": "10:15",
        "sessions": [
          [136]
        ],
        "startTime": "10:00"
      },
      {
        "endTime": "11:00",
        "sessions": [
          [139]
        ],
        "startTime": "10:15"
      },
      {
        "endTime": "11:40",
        "sessions": [
          [103],
          [120],
          [109]
        ],
        "startTime": "11:00"
      },
      {
        "endTime": "12:30",
        "sessions": [
          [129],
          [116],
          [109]
        ],
        "startTime": "11:50"
      },
      {
        "endTime": "14:00",
        "sessions": [
          [133]
        ],
        "startTime": "12:30"
      },
      {
        "endTime": "14:40",
        "sessions": [
          [101],
          [118],
          [107]
        ],
        "startTime": "14:00"
      },
      {
        "endTime": "15:30",
        "sessions": [
          [140],
          [126],
          [107]
        ],
        "startTime": "14:50"
      },
      {
        "endTime": "16:00",
        "sessions": [
          [134]
        ],
        "startTime": "15:30"
      },
      {
        "endTime": "16:40",
        "sessions": [
          [105],
          [127],
          [119]
        ],
        "startTime": "16:00"
      },
      {
        "endTime": "17:30",
        "sessions": [
          [112],
          [111],
          [119]
        ],
        "startTime": "16:50"
      },
      {
        "endTime": "18:20",
        "sessions": [
          [106],
          [125],
          [119]
        ],
        "startTime": "17:40"
      },
      {
        "endTime": "22:30",
        "sessions": [
          [137]
        ],
        "startTime": "18:30"
      }
    ],
    "tracks": [
      {"title": "Expo hall"},
      {"title": "Conference hall"},
      {"title": "Workshops hall"}
    ]
  };
}

Map mockSession() {
  return {
    "101": {
      "complexity": "Beginner",
      "description":
          "In this session, we will take a look at Windows and .NET support on Google Cloud Platform. We will build a simple ASP.NET app, deploy to Google Compute Engine and take a look at some of the tools and APIs available to .NET developers on Google Cloud Platform.",
      "id": 101,
      "language": "English",
      "presentation":
          "https://speakerdeck.com/gdglviv/mete-atamel-windows-and-net-on-google-cloud-platform",
      "speakers": [1],
      "tags": ["Cloud"],
      "title": "Windows and .NET on Google Cloud Platform"
    }
  };
}
