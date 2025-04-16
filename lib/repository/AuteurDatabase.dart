import 'package:bibliotheque/repository/Database.dart';

/// Classe pour gérer les opérations CRUD sur la table AUTEUR.
class AuteurDatabase {
  /// Création de l'attribut dbClient.
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajouter un auteur.
  ///
  /// [nomAuteur] : Nom de l'auteur.
  /// [detail] : Détails supplémentaires sur l'auteur.
  Future<int> ajouterAuteur(String nomAuteur, String detail) async {
    final db = await _dbClient.database;
    return await db.insert('AUTEUR', {
      'nomAuteur': nomAuteur,
      'detail': detail,
    });
  }

  /// Récupérer tous les auteurs.
  Future<List<Map<String, dynamic>>> obtenirTousLesAuteurs() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR');
  }

  /// Mettre à jour un auteur.
  ///
  /// [idAuteur] : Identifiant de l'auteur.
  /// [nomAuteur] : Nouveau nom de l'auteur.
  /// [detail] : Nouveaux détails sur l'auteur.
  Future<int> mettreAJourAuteur(int idAuteur, String nomAuteur, String detail) async {
    final db = await _dbClient.database;
    return await db.update(
      'AUTEUR',
      {'nomAuteur': nomAuteur, 'detail': detail},
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  /// Supprimer un auteur.
  ///
  /// [idAuteur] : Identifiant de l'auteur à supprimer.
  Future<int> supprimerAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.delete('AUTEUR', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  /// Obtenir la liste des auteurs triée par ordre alphabétique.
  Future<List<Map<String, dynamic>>> obtenirAuteursTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR', orderBy: 'nomAuteur ASC');
  }

  /// Récupérer les livres d'un auteur.
  ///
  /// [idAuteur] : Identifiant de l'auteur.
  Future<List<Map<String, dynamic>>> obtenirLivresParAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.query('LIVRE', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }
}
