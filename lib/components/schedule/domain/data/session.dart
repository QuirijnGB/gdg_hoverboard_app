class Session {
  String title, description, complexity;
  int id;

  Session(Map map) {
    title = map["title"];
    description = map["description"];
    complexity = map["complexity"];
    id = map["id"];
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
