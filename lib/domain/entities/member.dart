/// A community member shown on the map. Pure Dart: no map-plugin types here.
class Member {
  const Member({
    required this.id,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String city;
  final double latitude;
  final double longitude;
}
