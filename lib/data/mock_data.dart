import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

final List<CenterLocation> mockCenters = [
  CenterLocation(
    id: 'c1',
    title: 'Commissariat Central de Dakar',
    address: 'Avenue Malick Sy, Dakar',
    phone: '+221 33 823 25 29',
    location: const LatLng(14.6756, -17.4411),
  ),
  CenterLocation(
    id: 'c2',
    title: 'Préfecture de Dakar',
    address: 'Place de l\'Indépendance, Dakar',
    phone: '+221 33 889 31 00',
    location: const LatLng(14.6681, -17.4328),
  ),
  CenterLocation(
    id: 'c3',
    title: 'Commissariat de Dieuppeul',
    address: 'Allées Ababacar Sy, Dakar',
    phone: '+221 33 825 20 50',
    location: const LatLng(14.7153, -17.4589),
  ),
];

final List<Map<String, String>> requiredDocuments = [
  {'title': 'Extrait de naissance', 'desc': 'Délivré il y a moins de 3 mois'},
  {'title': 'Ancienne CNI', 'desc': 'Original de la carte à renouveler'},
  {'title': 'Justificatif de domicile', 'desc': 'Certificat de résidence ou facture Senelec/Sde'},
  {'title': 'Certificat de perte (si applicable)', 'desc': 'Délivré par le commissariat en cas de perte/vol'},
];