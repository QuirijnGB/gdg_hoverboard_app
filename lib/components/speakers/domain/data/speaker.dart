class Speaker {
  int id = -1;
  String name = "";
  String photoUrl = "";
  String country = "";
  String company = "";
  String bio = "";
  List<String> tags = [];

  Speaker(Map map) {
    if (map == null) {
      throw new Exception("Nah mate");
    }
    print("Create speaker $map");
    id = map["id"];
    name = map["name"];
    photoUrl = "https://hoverboard-demo.firebaseapp.com" + map["photoUrl"];
    country = map["country"];
    company = map["company"];
    bio = map["bio"];
    tags = map["tags"];
  }

  @override
  String toString() {
    return 'Speaker{id: $id, name: $name, photoUrl: $photoUrl, country: $country, company: $company, bio: $bio, tags: $tags}';
  }
}
