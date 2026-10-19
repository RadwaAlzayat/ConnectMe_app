import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/member.dart';

/// Turns a [Member] into a map marker. Tapping the marker opens an info
/// window with the member's name and city (the InfoWindow does this by itself).
class MemberMarker {
  MemberMarker._();

  static Marker fromMember(Member member) {
    return Marker(
      markerId: MarkerId(member.id),
      position: LatLng(member.latitude, member.longitude),
      infoWindow: InfoWindow(title: member.name, snippet: member.city),
    );
  }
}
