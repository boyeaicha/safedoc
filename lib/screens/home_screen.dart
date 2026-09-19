import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0: Démarches, 1: Catégories, 2: Administrations

  // État de l'utilisateur connecté
  bool _isLoggedIn = false;
  String _userFirstName = '';
  String _userLastName = '';
  String _userEmail = '';

  final List<Map<String, dynamic>> _adminList = [
    {
      'title': 'Préfecture de Dakar',
      'type': 'Délivrance de CNI & Titres d\'identité',
      'address': 'Place de l\'Indépendance, Dakar',
      'hours': 'Lundi - Vendredi : 08h00 - 17h00',
      'phone': '+221 33 823 10 10',
      'icon': Icons.location_city,
      'services': [
        'Délivrance et renouvellement de la CNI',
        'Traitement des passeports ordinaires',
        'Légalisation de documents officiels',
      ]
    },
    {
      'title': 'Mairie de Dakar (Hôtel de Ville)',
      'type': 'Actes d\'état civil & Certificats',
      'address': 'Allées Robert Delmas, Dakar',
      'hours': 'Lundi - Vendredi : 08h00 - 16h30',
      'phone': '+221 33 849 03 03',
      'icon': Icons.account_balance,
      'services': [
        'Délivrance des extraits d\'acte de naissance',
        'Certificats de mariage et de décès',
        'Légalisation des signatures',
      ]
    },
    {
      'title': 'Sous-Préfecture des Almadies',
      'type': 'Certificats de résidence & Enrôlement',
      'address': 'Ngor - Almadies, Dakar',
      'hours': 'Lundi - Vendredi : 08h00 - 16h00',
      'phone': '+221 33 820 12 34',
      'icon': Icons.domain,
      'services': [
        'Établissement du certificat de résidence',
        'Dépôt de dossiers pour la CNI',
        'Attestations administratives régionales',
      ]
    },
    {
      'title': 'Commissariat Central de Dakar',
      'type': 'Enrôlement CNI & Déclarations de perte',
      'address': 'Avenue Malick Sy, Dakar',
      'hours': '24h/24 (Urgences) - Bureau CNI : 08h00 - 17h00',
      'phone': '+221 33 821 24 24',
      'icon': Icons.local_police,
      'services': [
        'Enrôlement biométrique pour la CNI',
        'Déclarations de perte de documents d\'identité',
        'Main courante et certificats de perte',
      ]
    },
  ];

  // Ouverture du formulaire de création de compte
  void _openCreateAccountModal(BuildContext context, {String? customReason}) {
    final formKey = GlobalKey<FormState>();
    final lastNameController = TextEditingController();
    final firstNameController = TextEditingController();
    final emailController = TextEditingController();

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
                  Text(
                    customReason ?? 'Inscrivez-vous pour accéder à toutes vos démarches administratives.',
                    style: TextStyle(
                      fontSize: 12,
                      color: customReason != null ? const Color(0xFF00A651) : Colors.grey,
                      fontWeight: customReason != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Nom
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Veuillez renseigner votre nom' : null,
                  ),
                  const SizedBox(height: 12),

                  // Prénom
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Veuillez renseigner votre prénom' : null,
                  ),
                  const SizedBox(height: 12),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresse Email *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Veuillez renseigner votre email';
                      if (!val.contains('@') || !val.contains('.')) return 'Adresse email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Bouton Valider
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

                          Navigator.pop(ctx); // Ferme le formulaire

                          // Notification d'envoi d'email
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
                                'Bienvenue $fName $lName !\n\nUn e-mail de confirmation a été envoyé à $mail vous informant que votre compte safdoc est actif.',
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
                                      // Passage de l'application en mode "Connecté"
                                      setState(() {
                                        _isLoggedIn = true;
                                        _userFirstName = fName;
                                        _userLastName = lName;
                                        _userEmail = mail;
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
                // En-tête connecté
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
                // En-tête non connecté
                TextButton(
                  onPressed: () => _openCreateAccountModal(context),
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
            // Bannière
            Container(
              width: double.infinity,
              color: const Color(0xFF00A651),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                children: [
                  Text(
                    _isLoggedIn
                        ? 'Bienvenue, $_userFirstName !\nTrouvez vos démarches administratives'
                        : 'Trouvez vos démarches\nadministratives sans vous déplacer',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                              hintText: 'Rechercher une démarche (ex: carte d\'identité, permis)',
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

            // Onglets
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

            // Pied de page
            Container(
              width: double.infinity,
              color: const Color(0xFFF2F4F7),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Télécharger safdoc pour accéder à toutes vos démarches administratives',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.shop, color: Colors.white, size: 18),
                        label: const Text('Google Play', style: TextStyle(color: Colors.white, fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.apple, color: Colors.white, size: 18),
                        label: const Text('App Store', style: TextStyle(color: Colors.white, fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

  // Démarches
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
                onTap: () {
                  // Vérification si l'utilisateur est connecté
                  if (!_isLoggedIn) {
                    _openCreateAccountModal(
                      context,
                      customReason: 'Veuillez créer un compte safdoc pour commencer la démarche de CNI.',
                    );
                  } else {
                    _promptDepositCni(context);
                  }
                },
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
              _buildCard(
                title: 'Certificat de nationalité sénégalaise',
                icon: Icons.article_outlined,
                isBlurred: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _promptDepositCni(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.badge, color: Color(0xFF00A651)),
            SizedBox(width: 8),
            Text('Demande de CNI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Voulez-vous déposer une demande de Carte Nationale d\'Identité en ligne ?',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Non', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A651),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CniFormScreen(
                    userEmail: _userEmail,
                    initialName: '$_userFirstName $_userLastName',
                  ),
                ),
              );
            },
            child: const Text('Oui, déposer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Catégories
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
          const SizedBox(height: 4),
          const Text(
            'Tout citoyen sénégalais, à condition de pouvoir prouver sa nationalité sénégalaise. Concrètement, cela se décline par tranche d\'âge :',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: Colors.grey.shade300, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
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
              _buildTableRow('Enfants de 5 à 15 ans', 'Peuvent en faire la demande, mais ce n\'est pas obligatoire ; elle devient nécessaire seulement pour obtenir un passeport'),
              _buildTableRow('À partir de 15 ans', 'La carte est obligatoire pour toute personne âgée d\'au moins 15 ans, sous peine de sanctions'),
              _buildTableRow('Adultes majeurs', 'Éligibles de plein droit, qu\'ils résident au Sénégal ou à l\'étranger'),
              _buildTableRow('Sénégalais nés à l\'étranger', 'Éligibles également, avec des pièces justificatives supplémentaires (certificat de nationalité, acte de naissance transcrit, etc.)'),
              _buildTableRow('Sénégalais de la diaspora', 'Peuvent s\'enrôler via les missions consulaires et ambassades (Paris, Bruxelles, etc.)'),
            ],
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00A651).withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents généralement requis pour une première demande',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF00A651)),
                ),
                SizedBox(height: 8),
                Text(
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

  // Administrations
  Widget _buildAdministrationsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lieux de démarches & Administrations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cliquez sur une administration pour afficher les détails et démarches associées :',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _adminList.length,
            itemBuilder: (context, index) {
              final admin = _adminList[index];
              return Card(
                elevation: 0,
                color: const Color(0xFFF8F9FA),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE8F5E9),
                    child: Icon(admin['icon'] as IconData, color: const Color(0xFF00A651)),
                  ),
                  title: Text(
                    admin['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Text(
                    '${admin['type']}\n${admin['address']}',
                    style: const TextStyle(fontSize: 11, height: 1.3),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF00A651)),
                  onTap: () => _showAdminDetailDialog(context, admin),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAdminDetailDialog(BuildContext context, Map<String, dynamic> admin) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(admin['icon'] as IconData, color: const Color(0xFF00A651)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                admin['title'] as String,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAdminDetailRow(Icons.location_on, 'Adresse', admin['address'] as String),
              const SizedBox(height: 10),
              _buildAdminDetailRow(Icons.access_time, 'Horaires', admin['hours'] as String),
              const SizedBox(height: 10),
              _buildAdminDetailRow(Icons.phone, 'Contact', admin['phone'] as String),
              const SizedBox(height: 15),
              const Text(
                'Services & Démarches gérés :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF00A651)),
              ),
              const SizedBox(height: 6),
              ...(admin['services'] as List<String>).map(
                (service) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A651))),
                      Expanded(
                        child: Text(
                          service,
                          style: const TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer', style: TextStyle(color: Color(0xFF00A651), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 12),
              children: [
                TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
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
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBlurred ? Colors.grey.shade300 : const Color(0xFF00A651),
          width: isBlurred ? 0.8 : 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Icon(icon, size: 40, color: isBlurred ? Colors.grey : Colors.black87),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isBlurred ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: isBlurred ? null : onTap,
                    child: Text(
                      isBlurred ? 'Indisponible' : 'Voir plus',
                      style: TextStyle(
                        color: isBlurred ? Colors.grey : const Color(0xFF00A651),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isBlurred)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Color(0xFF00A651), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
            if (isBlurred)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  child: Container(
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String category, String status) {
    return TableRow(
      children: [
        _buildTableCell(category, isBold: true),
        _buildTableCell(status),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? const Color(0xFF00A651) : Colors.black87,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// FORMULAIRE DE DEPOT DE DEMANDE DE CNI
// -------------------------------------------------------------
class CniFormScreen extends StatefulWidget {
  final String userEmail;
  final String initialName;

  const CniFormScreen({
    super.key,
    required this.userEmail,
    this.initialName = '',
  });

  @override
  State<CniFormScreen> createState() => _CniFormScreenState();
}

class _CniFormScreenState extends State<CniFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final TextEditingController _ageController = TextEditingController();

  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  final Map<String, String?> _uploadedFiles = {
    'extrait_naissance': null,
    'certificat_residence': null,
    'photos_identite': null,
    'timbre_fiscal': null,
  };

  void _simulateFileUpload(String key, String docName) {
    setState(() {
      _uploadedFiles[key] = '$docName.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fichier "$docName.pdf" joint avec succès !'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF00A651),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      bool allFilesUploaded = _uploadedFiles.values.every((file) => file != null);

      if (!allFilesUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez joindre TOUS les documents obligatoires au format PDF.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Column(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF00A651), size: 50),
              SizedBox(height: 10),
              Text(
                'Demande transmise !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Votre dossier pour la Carte Nationale d\'Identité a été enregistré avec succès.\n\n'
                'Délai d\'attente estimé : 15 jours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 15),
              if (_notificationsEnabled)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00A651).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Color(0xFF00A651), size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Rappel activé : Un e-mail vous sera envoyé à ${widget.userEmail} un jour avant la date de retrait !',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF00A651), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A651),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Retour à l\'accueil', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A651),
        title: const Text('Dépôt de demande CNI', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulaire d\'enrôlement CNI',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tous les champs et tous les documents sous format PDF sont obligatoires.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Champ Nom complet
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom et Prénom *',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir votre nom complet';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Champ Âge
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Âge (en années) *',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez renseigner votre âge';
                  }
                  final int? age = int.tryParse(value);
                  if (age == null) {
                    return 'Saisissez un chiffre valide';
                  }
                  if (age < 15) {
                    return 'Vous devez avoir au moins 15 ans pour effectuer cette demande.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),
              const Text(
                'Documents obligatoires (.pdf uniquement)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF00A651)),
              ),
              const SizedBox(height: 12),

              _buildPdfUploader(
                label: '1. Extrait d\'acte de naissance (-6 mois) *',
                keyName: 'extrait_naissance',
                defaultFileName: 'extrait_naissance',
              ),
              _buildPdfUploader(
                label: '2. Certificat de résidence *',
                keyName: 'certificat_residence',
                defaultFileName: 'certificat_residence',
              ),
              _buildPdfUploader(
                label: '3. Photos d\'identité numérisées *',
                keyName: 'photos_identite',
                defaultFileName: 'photo_identite',
              ),
              _buildPdfUploader(
                label: '4. Timbre fiscal (2 000 FCFA) *',
                keyName: 'timbre_fiscal',
                defaultFileName: 'timbre_fiscal',
              ),

              const SizedBox(height: 15),

              // Option Activation Notification / Email de rappel (1 jour avant)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SwitchListTile(
                  activeColor: const Color(0xFF00A651),
                  title: const Text(
                    'Activer les rappels par email',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Recevez un email de rappel 1 jour avant la date officielle de retrait de votre pièce d\'identité.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Soumettre la demande',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfUploader({
    required String label,
    required String keyName,
    required String defaultFileName,
  }) {
    final bool isUploaded = _uploadedFiles[keyName] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUploaded ? const Color(0xFF00A651) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUploaded ? Icons.picture_as_pdf : Icons.upload_file,
            color: isUploaded ? Colors.red : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                if (isUploaded)
                  Text(
                    _uploadedFiles[keyName]!,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF00A651), fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _simulateFileUpload(keyName, defaultFileName),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded ? Colors.grey.shade300 : const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text(
              isUploaded ? 'Modifier' : 'Joindre PDF',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}