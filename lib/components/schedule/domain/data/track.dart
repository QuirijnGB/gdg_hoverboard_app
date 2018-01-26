class Track {
  String title;

  Track(Map map) {
    title = map["title"];
  }

  static List<Track> mapTracks(List map) {
    List<Track> tracks = [];
    if (map != null) {
      map.forEach((v) {
        tracks.add(new Track(v));
      });
    }
    return tracks;
  }

  @override
  String toString() {
    return 'Track{title: $title}';
  }
}
