// lib/models/commissariats_data.dart

class Commissariat {
  final String nom;
  final String region;
  final String departement;
  final String adresse;
  final String telephone;
  final String horaires;

  const Commissariat({
    required this.nom,
    required this.region,
    required this.departement,
    required this.adresse,
    required this.telephone,
    this.horaires = "24h/24 - 7j/7",
  });
}

class CommissariatsData {
  static const List<Commissariat> liste = [
    // --- DAKAR ---
    Commissariat(
      nom: "Commissariat Central de Dakar",
      region: "Dakar",
      departement: "Dakar",
      adresse: "Avenue Malick Sy x Rue 6, Medina, Dakar",
      telephone: "+221 33 823 25 29",
    ),
    Commissariat(
      nom: "Commissariat du Plateau",
      region: "Dakar",
      departement: "Dakar",
      adresse: "Rue Vincens x Boulevard République, Dakar",
      telephone: "+221 33 821 34 50",
    ),
    Commissariat(
      nom: "Commissariat de la Médina",
      region: "Dakar",
      departement: "Dakar",
      adresse: "Avenue Blaise Diagne x Rue 11, Médina",
      telephone: "+221 33 822 10 05",
    ),
    Commissariat(
      nom: "Commissariat des Parcelles Assainies",
      region: "Dakar",
      departement: "Dakar",
      adresse: "Unité 15, Parcelles Assainies, Dakar",
      telephone: "+221 33 835 10 03",
    ),
    Commissariat(
      nom: "Commissariat de Grand-Yoff",
      region: "Dakar",
      departement: "Dakar",
      adresse: "Quartier Arafat, Grand-Yoff",
      telephone: "+221 33 827 12 10",
    ),
    Commissariat(
      nom: "Commissariat Central de Pikine",
      region: "Dakar",
      departement: "Pikine",
      adresse: "Tally Boubess, Pikine",
      telephone: "+221 33 834 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Guédiawaye",
      region: "Dakar",
      departement: "Guédiawaye",
      adresse: "Cité WPF, Stade Ndiarème, Guédiawaye",
      telephone: "+221 33 837 10 15",
    ),
    Commissariat(
      nom: "Commissariat Central de Rufisque",
      region: "Dakar",
      departement: "Rufisque",
      adresse: "Quartier Escale, Rufisque",
      telephone: "+221 33 836 10 05",
    ),
    Commissariat(
      nom: "Commissariat de Keur Massar",
      region: "Dakar",
      departement: "Keur Massar",
      adresse: "Rond-point Keur Massar",
      telephone: "+221 33 837 50 00",
    ),

    // --- THIES ---
    Commissariat(
      nom: "Commissariat Central de Thiès",
      region: "Thiès",
      departement: "Thiès",
      adresse: "Avenue Léopold Sédar Senghor, Thiès",
      telephone: "+221 33 951 10 05",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Mbour",
      region: "Thiès",
      departement: "Mbour",
      adresse: "Quartier Escale, Mbour",
      telephone: "+221 33 957 10 02",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Tivaouane",
      region: "Thiès",
      departement: "Tivaouane",
      adresse: "Quartier El Hadji Malick Sy, Tivaouane",
      telephone: "+221 33 955 10 02",
    ),

    // --- SAINT-LOUIS ---
    Commissariat(
      nom: "Commissariat Central de Saint-Louis",
      region: "Saint-Louis",
      departement: "Saint-Louis",
      adresse: "Île de Saint-Louis, Rue Genouly",
      telephone: "+221 33 961 10 05",
    ),
    Commissariat(
      nom: "Commissariat de Sor",
      region: "Saint-Louis",
      departement: "Saint-Louis",
      adresse: "Quartier Sor, près de la gare, Saint-Louis",
      telephone: "+221 33 961 20 14",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Richard-Toll",
      region: "Saint-Louis",
      departement: "Dagana",
      adresse: "Quartier Escale, Richard-Toll",
      telephone: "+221 33 963 10 02",
    ),

    // --- DIOURBEL ---
    Commissariat(
      nom: "Commissariat Central de Diourbel",
      region: "Diourbel",
      departement: "Diourbel",
      adresse: "Quartier Escale, Diourbel",
      telephone: "+221 33 971 10 02",
    ),
    Commissariat(
      nom: "Commissariat Spécial de Touba",
      region: "Diourbel",
      departement: "Mbacké",
      adresse: "Près de la Grande Mosquée, Touba",
      telephone: "+221 33 978 10 05",
    ),

    // --- AUTRES REGIONS ---
    Commissariat(
      nom: "Commissariat Central de Kaolack",
      region: "Kaolack",
      departement: "Kaolack",
      adresse: "Quartier Kasnack, Kaolack",
      telephone: "+221 33 941 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Ziguinchor",
      region: "Ziguinchor",
      departement: "Ziguinchor",
      adresse: "Avenue Cherif Macky Aidara, Ziguinchor",
      telephone: "+221 33 991 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Tambacounda",
      region: "Tambacounda",
      departement: "Tambacounda",
      adresse: "Quartier Liberté, Tambacounda",
      telephone: "+221 33 981 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Kolda",
      region: "Kolda",
      departement: "Kolda",
      adresse: "Quartier Sare Keita, Kolda",
      telephone: "+221 33 996 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Louga",
      region: "Louga",
      departement: "Louga",
      adresse: "Quartier Artillerie, Louga",
      telephone: "+221 33 967 10 02",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Fatick",
      region: "Fatick",
      departement: "Fatick",
      adresse: "Quartier Escale, Fatick",
      telephone: "+221 33 949 10 02",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Matam",
      region: "Matam",
      departement: "Matam",
      adresse: "Quartier Soubalo, Matam",
      telephone: "+221 33 966 10 02",
    ),
    Commissariat(
      nom: "Commissariat Central de Kédougou",
      region: "Kédougou",
      departement: "Kédougou",
      adresse: "Quartier Togoro, Kédougou",
      telephone: "+221 33 988 10 02",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Sédhiou",
      region: "Sédhiou",
      departement: "Sédhiou",
      adresse: "Quartier Santassou, Sédhiou",
      telephone: "+221 33 995 10 02",
    ),
    Commissariat(
      nom: "Commissariat Urbain de Kaffrine",
      region: "Kaffrine",
      departement: "Kaffrine",
      adresse: "Quartier Escale, Kaffrine",
      telephone: "+221 33 946 10 02",
    ),
  ];
}