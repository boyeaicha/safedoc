// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/commissariats_data.dart';
import 'cni_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0: Démarches, 1: Catégories, 2: Administrations

  bool _isLoggedIn = false;
  String _userFirstName = '';
  String _userLastName = '';
  String _userEmail = '';
  String _userAddress = '';
  String _assignedCommissariat = '';

  String _adminSearchQuery = "";
  String _selectedRegion = "Toutes";

  final List<String> _regions = [
    "Toutes",
    "Dakar",
    "Thiès",
    "Saint-Louis",
    "Diourbel",
    "Ziguinchor",
    "Kaolack",
    "Tambacounda",
    "Kolda",
    "Louga",
    "Fatick",
    "Matam",
    "Kédougou",
    "Sédhiou",
    "Kaffrine",
  ];

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

  void _openLoginModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Connexion safdoc',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Connectez-vous pour suivre l\'état de vos démarches et consulter votre point de retrait.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Adresse Email *',
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.email, color: Color(0xFF00A651)),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Veuillez entrer votre email';
                          if (!val.contains('@') || !val.contains('.')) return 'Adresse email invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe *',
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF00A651)),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Veuillez entrer votre mot de passe';
                          if (val.length < 4) return 'Mot de passe trop court';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A651),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final String mail = emailController.text.trim();

                              String extractedName = mail.split('@')[0];
                              if (extractedName.contains('.')) {
                                extractedName = extractedName.split('.')[0];
                              }
                              if (extractedName.isNotEmpty) {
                                extractedName = extractedName[0].toUpperCase() + extractedName.substring(1);
                              }

                              final String comm = _findCommissariatByAddress(mail);

                              Navigator.pop(ctx);

                              setState(() {
                                _isLoggedIn = true;
                                _userFirstName = extractedName;
                                _userLastName = '';
                                _userEmail = mail;
                                _assignedCommissariat = comm;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF00A651),
                                  content: Text('Ravi de vous revoir $extractedName ! Connexion réussie.'),
                                ),
                              );
                            }
                          },
                          child: const Text('Se connecter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openCreateAccountModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final lastNameController = TextEditingController();
    final firstNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Créer un compte safdoc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Inscrivez-vous pour déterminer automatiquement votre point de retrait CNI.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.badge, color: Color(0xFF00A651)),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Veuillez renseigner votre nom' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.person, color: Color(0xFF00A651)),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Veuillez renseigner votre prénom' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresse Email *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.email, color: Color(0xFF00A651)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Veuillez renseigner votre email';
                      if (!val.contains('@') || !val.contains('.')) return 'Adresse email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse / Quartier de résidence *',
                      hintText: 'Ex: Saint Louis, Medina, Pikine...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.location_on, color: Color(0xFF00A651)),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Veuillez renseigner votre adresse' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF00A651)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Veuillez créer un mot de passe';
                      if (val.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final String fName = firstNameController.text.trim();
                          final String lName = lastNameController.text.trim();
                          final String mail = emailController.text.trim();
                          final String addr = addressController.text.trim();

                          final String matchedComm = _findCommissariatByAddress(addr);

                          Navigator.pop(ctx);

                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Column(
                                children: [
                                  Icon(Icons.mark_email_read, color: Color(0xFF00A651), size: 50),
                                  SizedBox(height: 10),
                                  Text(
                                    'Compte créé avec succès !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Bienvenue $fName $lName !\n\n'
                                'Basé sur votre adresse ($addr), votre point de retrait attitré pour votre CNI sera :\n\n'
                                '📍 $matchedComm\n\n'
                                'Un e-mail récapitulatif a été envoyé à $mail.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13, height: 1.4),
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00A651),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogCtx);
                                      setState(() {
                                        _isLoggedIn = true;
                                        _userFirstName = fName;
                                        _userLastName = lName;
                                        _userEmail = mail;
                                        _userAddress = addr;
                                        _assignedCommissariat = matchedComm;
                                      });
                                    },
                                    child: const Text('Accéder à l\'accueil', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Créer mon compte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _promptDepositCni(BuildContext context) {
    if (!_isLoggedIn) {
      _openCreateAccountModal(context);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CniFormScreen(
          initialName: '$_userFirstName $_userLastName'.trim(),
          initialEmail: _userEmail,
          initialAddress: _userAddress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'safdoc',
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: _isLoggedIn
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF00A651),
                        radius: 16,
                        child: Text(
                          _userFirstName.isNotEmpty ? _userFirstName[0].toUpperCase() : 'U',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _userFirstName,
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                        onSelected: (value) {
                          if (value == 'logout') {
                            setState(() {
                              _isLoggedIn = false;
                              _userFirstName = '';
                              _userLastName = '';
                              _userEmail = '';
                              _userAddress = '';
                              _assignedCommissariat = '';
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            enabled: false,
                            value: 'email',
                            child: Text(_userEmail, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ),
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Déconnexion', style: TextStyle(color: Colors.red, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            : [
                TextButton(
                  onPressed: () => _openLoginModal(context),
                  child: const Text('Se connecter', style: TextStyle(color: Colors.black87, fontSize: 12)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 8, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () => _openCreateAccountModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A651),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Créer un compte', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF00A651),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                children: [
                  Text(
                    _isLoggedIn
                        ? 'Bienvenue, $_userFirstName !\nPoint de retrait : ${_assignedCommissariat.split('(')[0]}'
                        : 'Trouvez vos démarches\nadministratives sans vous déplacer',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Rechercher une démarche (ex: CNI)',
                              hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          child: const Text('Rechercher', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabPill('Démarches', 0),
                    _buildTabPill('Catégories', 1),
                    _buildTabPill('Administrations', 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedTabIndex == 0) ...[
              _buildDemarchesContent(),
            ] else if (_selectedTabIndex == 1) ...[
              _buildCategoriesContent(),
            ] else ...[
              _buildAdministrationsContent(),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A651) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDemarchesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00A651).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF00A651), size: 16),
                SizedBox(width: 6),
                Text(
                  'Démarches disponibles (1 active)',
                  style: TextStyle(
                    color: Color(0xFF00A651),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCard(
                title: 'Carte Nationale d\'Identité (CNI)',
                icon: Icons.badge_outlined,
                isBlurred: false,
                onTap: () => _promptDepositCni(context),
              ),
              _buildCard(
                title: 'Casier judiciaire (juridictions pilotes)',
                icon: Icons.person_outline,
                isBlurred: true,
                onTap: () {},
              ),
              _buildCard(
                title: 'Attestation de non-appartenance à la TP',
                icon: Icons.description_outlined,
                isBlurred: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required bool isBlurred,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isBlurred ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isBlurred ? Colors.grey.shade300 : const Color(0xFF00A651),
            width: isBlurred ? 1 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: isBlurred ? Colors.grey : const Color(0xFF00A651), size: 28),
                if (isBlurred)
                  const Text('Bientôt', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isBlurred ? Colors.grey : Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  isBlurred ? 'En cours de déploiement' : 'Accéder au service',
                  style: TextStyle(
                    fontSize: 11,
                    color: isBlurred ? Colors.grey : const Color(0xFF00A651),
                    fontWeight: isBlurred ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                if (!isBlurred) const Icon(Icons.arrow_forward, size: 12, color: Color(0xFF00A651)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Éligibilité et tranches d\'âge',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(
                  text: 'Tout citoyen sénégalais',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ', à condition de pouvoir prouver sa nationalité sénégalaise. Concrètement, cela se décline par tranche d\'âge :',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
                width: 1,
                style: BorderStyle.solid,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1.1),
                1: FlexColumnWidth(2.0),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
                  children: [
                    _buildTableCell('Catégorie', isHeader: true),
                    _buildTableCell('Statut', isHeader: true),
                  ],
                ),
                _buildTableRow(
                  'Enfants de 5 à 15 ans',
                  'Peuvent en faire la demande, mais ce n\'est pas obligatoire ; elle devient nécessaire seulement pour obtenir un passeport',
                ),
                _buildTableRow(
                  'À partir de 15 ans',
                  'La carte est obligatoire pour toute personne âgée d\'au moins 15 ans, sous peine de sanctions',
                ),
                _buildTableRow(
                  'Adultes majeurs',
                  'Éligibles de plein droit, qu\'ils résident au Sénégal ou à l\'étranger',
                ),
                _buildTableRow(
                  'Sénégalais nés à l\'étranger',
                  'Éligibles également, avec des pièces justificatives supplémentaires (certificat de nationalité, acte de naissance transcrit, etc.)',
                ),
                _buildTableRow(
                  'Sénégalais de la diaspora',
                  'Peuvent s\'enrôler via les missions consulaires et ambassades (Paris, Bruxelles, etc.)',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cas particulier — les non-Sénégalais',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          const Text(
            'Les étrangers n\'ont pas droit à la CNI sénégalaise classique, mais il existe un équivalent : la carte d\'identité de réfugié, délivrée uniquement par la Commission Nationale d\'Éligibilité pour les personnes de nationalité étrangère âgées d\'au moins 16 ans ayant obtenu le statut de réfugié à l\'issue d\'une procédure individuelle.',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF00A651).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.folder_special, color: Color(0xFF00A651), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Documents généralement requis pour une première demande',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A651),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Un extrait de naissance de moins de six mois, un certificat de résidence délivré par le chef de quartier ou de village, deux photos d\'identité récentes sur fond blanc, et un timbre fiscal de 2 000 FCFA. Pour les Sénégalais nés au Sénégal n\'ayant jamais eu de carte, s\'ajoutent généralement un extrait de naissance original, un certificat de nationalité sénégalaise, et une copie de la carte d\'identité du père ou de la mère.',
                  style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 11,
          color: isHeader ? const Color(0xFF00A651) : Colors.black87,
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2) {
    return TableRow(
      children: [
        _buildTableCell(col1, isHeader: true),
        _buildTableCell(col2),
      ],
    );
  }

  Widget _buildAdministrationsContent() {
    final filteredList = CommissariatsData.liste.where((item) {
      final matchesSearch = item.nom.toLowerCase().contains(_adminSearchQuery.toLowerCase()) ||
          item.adresse.toLowerCase().contains(_adminSearchQuery.toLowerCase()) ||
          item.departement.toLowerCase().contains(_adminSearchQuery.toLowerCase());
      final matchesRegion = _selectedRegion == "Toutes" || item.region == _selectedRegion;
      return matchesSearch && matchesRegion;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Points de Retrait & Commissariats du Sénégal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Trouvez le commissariat de police correspondant à votre zone :',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => _adminSearchQuery = value),
            decoration: InputDecoration(
              hintText: 'Rechercher un commissariat ou une ville...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00A651)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                final region = _regions[index];
                final isSelected = region == _selectedRegion;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(region, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFFC107),
                    onSelected: (bool selected) {
                      setState(() => _selectedRegion = region);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          filteredList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: Text('Aucun commissariat trouvé.')),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final comm = filteredList[index];
                    return Card(
                      elevation: 0,
                      color: const Color(0xFFF8F9FA),
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F5E9),
                          child: Icon(Icons.local_police, color: Color(0xFF00A651)),
                        ),
                        title: Text(comm.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('📍 ${comm.adresse} (${comm.region})', style: const TextStyle(fontSize: 11)),
                            Text('📞 ${comm.telephone}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}