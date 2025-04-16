import 'package:flutter/foundation.dart';
import '../../model/Auteur.dart';
import '../../repository/AuteurDatabase.dart';
import '../../repository/LivreDatabase.dart';

/// ViewModel pour gérer les opérations CRUD sur les auteurs.
class AuteurViewModel with ChangeNotifier {
  final LivreDatabase _livreDb = LivreDatabase();
  final AuteurDatabase _auteurDb = AuteurDatabase();
  List<Auteur> _auteurs = [];

  /// Liste des auteurs.
  List<Auteur> get auteurs => _auteurs;

  /// Constructeur du ViewModel pour les auteurs.
  AuteurViewModel() {
    chargerAuteurs(); // Charger les auteurs lors de l'initialisation.
  }

  /// Récupérer la liste des auteurs.
  Future<void> chargerAuteurs() async {
    try {
      print('Chargement des auteurs...');
      final List<Map<String, dynamic>> auteursMap = await _auteurDb.obtenirTousLesAuteurs();
      _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
      print('Auteurs chargés: $_auteurs');
      notifyListeners(); // Notifier la vue des changements.
    } catch (e) {
      print("Erreur lors de la récupération des auteurs: $e");
    }
  }

  /// Ajouter un auteur avec un nom et un détail.
  Future<void> ajouterAuteur(String nomAuteur, String detail) async {
    await _auteurDb.ajouterAuteur(nomAuteur, detail);  // Ajouter le détail à la BDD.
    await chargerAuteurs(); // Recharger les auteurs après ajout.
  }

  /// Mettre à jour un auteur existant avec un nom et un détail.
  Future<void> mettreAJourAuteur(int idAuteur, String nomAuteur, String detail) async {
    await _auteurDb.mettreAJourAuteur(idAuteur, nomAuteur, detail);  // Inclure le détail dans la mise à jour.
    await chargerAuteurs();
  }

  /// Supprimer un auteur.
  Future<void> supprimerAuteur(int idAuteur) async {
    // Supprime les livres de l'auteur.
    await _livreDb.supprimerLivresParAuteurId(idAuteur);
    // Supprime l'auteur.
    await _auteurDb.supprimerAuteur(idAuteur);
    // Met à jour la liste.
    await chargerAuteurs();
  }
}
