import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceTile extends StatelessWidget {
  final CenterLocation center;
  final VoidCallback onTap;

  const PlaceTile({
    super.key,
    required this.center,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.location_on, color: Colors.white),
        ),
        title: Text(
          center.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${center.address} • ${center.phone}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}