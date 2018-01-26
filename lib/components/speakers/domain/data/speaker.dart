class Speaker {
  int id = -1;
  String name = "";
  String photoUrl = "";
  String country = "";
  List<String> tags = [];

  Speaker(Map map) {
    if (map == null) {
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
