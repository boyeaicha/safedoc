// lib/screens/cni_form_screen.dart

import 'package:flutter/material.dart';
import '../models/commissariats_data.dart';

class CniFormScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialAddress;

  const CniFormScreen({
    super.key,
    this.initialName = '',
    this.initialEmail = '',
    this.initialAddress = '',
  });

  @override
  State<CniFormScreen> createState() => _CniFormScreenState();
}

class _CniFormScreenState extends State<CniFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;

  bool _birthCertificateUploaded = false;
  bool _residenceCertificateUploaded = false;
  bool _photoUploaded = false;
  bool _taxStampUploaded = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _addressController = TextEditingController(text: widget.initialAddress);
    _ageController = TextEditingController();
  }

  String _findCommissariatByAddress(String address) {
    String lowerAddress = address.toLowerCase();
    String normalizedAddress = lowerAddress
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('-', ' ');

    for (var comm in CommissariatsData.liste) {
      String normRegion = comm.region.toLowerCase().replaceAll('-', ' ');
      String normDept = comm.departement.toLowerCase().replaceAll('-', ' ');
      String normNom = comm.nom.toLowerCase().replaceAll('-', ' ');
      String normAdresse = comm.adresse.toLowerCase().replaceAll('-', ' ');

      if (normalizedAddress.contains(normRegion) ||
          normalizedAddress.contains(normDept) ||
          normNom.contains(normalizedAddress) ||
          normalizedAddress.contains(normAdresse)) {
        return "${comm.nom} (${comm.adresse})";
      }
    }

    return "Commissariat Central de Dakar (Avenue Malick Sy x Rue 6)";
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00A651);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pré-demande de CNI Biométrique"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: primaryColor),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Remplissez les informations ci-dessous. Votre point de retrait sera automatiquement attribué selon votre quartier.",
                        style: TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Informations personnelles",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: "Nom complet *",
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.person, color: primaryColor),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Veuillez saisir votre nom complet" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Âge *",
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.cake, color: primaryColor),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Veuillez saisir votre âge";
                  final age = int.tryParse(val.trim());
                  if (age == null) return "Veuillez entrer un âge valide";
                  if (age < 15) return "La CNI est réservée aux personnes de 15 ans et plus";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Adresse Email *",
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.email, color: primaryColor),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Veuillez saisir votre e-mail";
                  if (!val.contains('@') || !val.contains('.')) return "Adresse e-mail invalide";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Adresse / Quartier de résidence *",
                  hintText: "Ex: Saint Louis, Parcelles, Thiès...",
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.location_on, color: primaryColor),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Veuillez renseigner votre adresse" : null,
              ),
              const SizedBox(height: 24),
              const Text(
                "Documents justificatifs (PDF / Image)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 10),
              _buildUploadTile(
                title: "Extrait de naissance (- de 6 mois)",
                isUploaded: _birthCertificateUploaded,
                onTap: () => setState(() => _birthCertificateUploaded = !_birthCertificateUploaded),
              ),
              _buildUploadTile(
                title: "Certificat de résidence",
                isUploaded: _residenceCertificateUploaded,
                onTap: () => setState(() => _residenceCertificateUploaded = !_residenceCertificateUploaded),
              ),
              _buildUploadTile(
                title: "Photo d'identité (Fond blanc)",
                isUploaded: _photoUploaded,
                onTap: () => setState(() => _photoUploaded = !_photoUploaded),
              ),
              _buildUploadTile(
                title: "Timbre fiscal (2 000 FCFA)",
                isUploaded: _taxStampUploaded,
                onTap: () => setState(() => _taxStampUploaded = !_taxStampUploaded),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_birthCertificateUploaded || !_residenceCertificateUploaded || !_photoUploaded || !_taxStampUploaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text("Veuillez joindre tous les documents obligatoires."),
                          ),
                        );
                        return;
                      }

                      final matchedComm = _findCommissariatByAddress(_addressController.text.trim());

                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Column(
                            children: [
                              Icon(Icons.check_circle, color: primaryColor, size: 50),
                              SizedBox(height: 10),
                              Text(
                                "Demande soumise !",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: Text(
                            "Votre dossier de pré-demande de CNI a été enregistré avec succès.\n\n"
                            "📍 Point de retrait attitré :\n$matchedComm\n\n"
                            "Un e-mail de confirmation contenant votre récépissé a été envoyé à ${_emailController.text.trim()}.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                          actions: [
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context);
                                },
                                child: const Text("Retour à l'accueil", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Soumettre la pré-demande",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: isUploaded ? const Color(0xFFE8F5E9) : const Color(0xFFF8F9FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isUploaded ? const Color(0xFF00A651) : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.cloud_upload,
          color: isUploaded ? const Color(0xFF00A651) : Colors.grey,
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        subtitle: Text(
          isUploaded ? "Document joint (PDF)" : "Cliquez pour charger le fichier",
          style: TextStyle(fontSize: 11, color: isUploaded ? const Color(0xFF00A651) : Colors.grey),
        ),
        trailing: Icon(
          isUploaded ? Icons.edit : Icons.add_a_photo,
          size: 18,
          color: isUploaded ? const Color(0xFF00A651) : Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }
}