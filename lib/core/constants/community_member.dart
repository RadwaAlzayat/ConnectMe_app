import '../../domain/entities/member.dart';

/// Hardcoded member locations in four different cities, as the brief asks.
const List<Member> communityMembers = [
  Member(
    id: 'member_cairo',
    name: 'Sara Ahmed',
    city: 'Cairo',
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  Member(
    id: 'member_london',
    name: 'James Wilson',
    city: 'London',
    latitude: 51.5074,
    longitude: -0.1278,
  ),
  Member(
    id: 'member_dubai',
    name: 'Layla Hassan',
    city: 'Dubai',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  Member(
    id: 'member_riyadh',
    name: 'Khaled Nasser',
    city: 'Riyadh',
    latitude: 24.7136,
    longitude: 46.6753,
  ),
];
