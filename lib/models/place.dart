import 'package:google_maps_flutter/google_maps_flutter.dart';

class CenterLocation {
  final String id;
  final String title;
  final String address;
  final String phone;
  final LatLng location;

  CenterLocation({
    required this.id,
    required this.title,
    required this.address,
    required this.phone,
    required this.location,
  });
}