class TimeSlot {
  String startTime;
  String endTime;
  List sessionIds = [];

  TimeSlot(Map map) {
    startTime = map["startTime"];
    endTime = map["endTime"];
    sessionIds = map["sessions"];
  }

  @override
  String toString() {
    return 'TimeSlot{startTime: $startTime, endTime: $endTime}';
  }

  static List<TimeSlot> mapTimeSlots(List map) {
    List<TimeSlot> timeslots = [];
    if (map != null) {
      map.forEach((v) {
        timeslots.add(new TimeSlot(v));
      });
    }
    return timeslots;
  }
}
