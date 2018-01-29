

class Session {
  String title, description, complexity, language, image;
  int id;
  List<int> speakerIds;
  List<String> tags = [];

  Session(Map map) {
    title = map["title"];
    description = map["description"];
    complexity = map["complexity"];
    language = map["language"];
    speakerIds = map["speakers"];
    tags = map["tags"];
    id = map["id"];
    image = map["image"] != null
        ? "https://hoverboard-demo.firebaseapp.com${map["image"]}"
        : "";
  }

  static List<Session> mapSessions(Map map) {
    List<Session> sessions = [];
    if (map != null) {
      map.forEach((k, v) {
        sessions.add(new Session(v));
      });
    }
    return sessions;
  }

  @override
  String toString() {
    return 'Session{title: $title, description: $description, complexity: $complexity, id: $id}';
  }
}
