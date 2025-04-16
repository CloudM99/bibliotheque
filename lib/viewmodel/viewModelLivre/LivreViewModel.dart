import 'package:flutter/foundation.dart';
import '../../model/Livre.dart';
import '../../repository/LivreDatabase.dart';

/// ViewModel pour gérer les opérations CRUD sur les livres.
class LivreViewModel with ChangeNotifier {
  final LivreDatabase _livreDb = LivreDatabase();
  List<Livre> _livres = [];

  /// Liste des livres.
  List<Livre> get livres => _livres;

  /// Charger les livres depuis la base de données.
  Future<void> chargerLivres() async {
    final livresMap = await _livreDb.obtenirTousLesLivres();
    // Utiliser Future.wait pour récupérer les livres et les auteurs.
    final List<Livre?> livres = await Future.wait(
      livresMap.map((livreMap) async {
        final auteur = await _livreDb.obtenirAuteurParId(livreMap['idAuteur']);
        // Vérifiez si l'auteur a été trouvé.
        if (auteur == null) {
          return null; // Retournez null si l'auteur n'est pas trouvé.
        } else {
          return Livre.fromMap(livreMap, auteur); // Créer le livre avec l'auteur trouvé.
        }
      }),
    );
    // Filtrer les livres pour ne garder que ceux qui ne sont pas null.
    _livres = livres.where((livre) => livre != null).cast<Livre>().toList();
    notifyListeners(); // Notifier la vue de la mise à jour.
  }

  /// Ajouter un nouveau livre avec le résumé.
  Future<void> ajouterLivre(String nomLivre, int idAuteur, String resume, String? jacketPath) async {
    await _livreDb.ajouterLivre(nomLivre, idAuteur, resume, jacketPath); // Ajouter un livre avec le résumé.
    await chargerLivres(); // Recharger les livres après ajout.
  }

  /// Mettre à jour un livre existant avec le résumé.
  Future<void> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur, String resume, String? jacketPath) async {
    await _livreDb.mettreAJourLivre(idLivre, nomLivre, idAuteur, resume, jacketPath); // Mettre à jour avec le résumé.
    await chargerLivres(); // Recharger les livres après mise à jour.
  }

  /// Supprimer un livre.
  Future<void> supprimerLivre(int idLivre) async {
    await _livreDb.supprimerLivre(idLivre);
    await chargerLivres();
  }
}
