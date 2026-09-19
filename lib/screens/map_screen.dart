import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final List<CenterLocation> centers;
  final LatLng? initialPosition;

  const MapScreen({
    super.key,
    required this.centers,
    this.initialPosition,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final defaultPosition = widget.initialPosition ??
        (widget.centers.isNotEmpty
            ? widget.centers.first.location
            : const LatLng(14.6937, -17.4441));

    final Set<Marker> markers = widget.centers.map((center) {
      return Marker(
        markerId: MarkerId(center.id),
        position: center.location,
        infoWindow: InfoWindow(
          title: center.title,
          snippet: '${center.address} | Tel: ${center.phone}',
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des centres CNI'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<MapType>(
            onSelected: (type) => setState(() => _currentMapType = type),
            itemBuilder: (context) => [
              const PopupMenuItem(value: MapType.normal, child: Text('Normal')),
              const PopupMenuItem(value: MapType.satellite, child: Text('Satellite')),
              const PopupMenuItem(value: MapType.hybrid, child: Text('Hybride')),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        mapType: _currentMapType,
        initialCameraPosition: CameraPosition(
          target: defaultPosition,
          zoom: 13,
        ),
        markers: markers,
      ),
    );
  }
}