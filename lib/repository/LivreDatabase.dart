import 'Database.dart';
import '../model/Auteur.dart';

/// Classe pour gérer les opérations CRUD sur la table LIVRE.
class LivreDatabase {
  /// Création de l'attribut dbClient.
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajouter un livre.
  ///
  /// [nomLivre] : Nom du livre.
  /// [idAuteur] : Identifiant de l'auteur du livre.
  /// [resume] : Résumé du livre.
  /// [jacketPath] : Chemin vers la couverture du livre.
  Future<int> ajouterLivre(String nomLivre, int idAuteur, String resume, String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'resume': resume,
      'jacket': jacketPath,
    });
  }

  /// Récupérer tous les livres.
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  /// Mettre à jour un livre.
  ///
  /// [idLivre] : Identifiant du livre.
  /// [nomLivre] : Nouveau nom du livre.
  /// [idAuteur] : Nouvel identifiant de l'auteur du livre.
  /// [resume] : Nouveau résumé du livre.
  /// [jacketPath] : Nouveau chemin vers la couverture du livre.
  Future<int> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur, String resume, String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.update('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'resume': resume,
      'jacket': jacketPath,
    }, where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  /// Supprimer un livre.
  ///
  /// [idLivre] : Identifiant du livre à supprimer.
  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  /// Supprimer les livres d'un auteur.
  ///
  /// [idAuteur] : Identifiant de l'auteur dont les livres doivent être supprimés.
  Future<int> supprimerLivresParAuteurId(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  /// Obtenir un auteur par son identifiant.
  ///
  /// [idAuteur] : Identifiant de l'auteur.
  Future<Auteur?> obtenirAuteurParId(int idAuteur) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AUTEUR',
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Auteur.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
