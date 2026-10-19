import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/community_member.dart';
import '../widgets/member_marker.dart';

/// Full-screen Google Map with one marker per community member.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Zoom 3 centered between the cities so all four markers are visible
  // and far enough apart to tap.
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(33, 27),
    zoom: 3,
  );

  static final Set<Marker> _markers = communityMembers
      .map(MemberMarker.fromMember)
      .toSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Map')),
      body: GoogleMap(initialCameraPosition: _initialCamera, markers: _markers),
    );
  }
}
