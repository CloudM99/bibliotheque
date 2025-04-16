import 'Auteur.dart';

/// Classe représentant un livre.
class Livre {
  int? _idLivre;
  String _nomLivre;
  Auteur _auteur; /// Auteur du livre.
  String _resume;
  String? _jacketPath;

  /// Constructeur de la classe Livre.
  ///
  /// [idLivre] : Identifiant unique du livre.
  /// [nomLivre] : Nom du livre.
  /// [auteur] : Auteur du livre.
  /// [resume] : Résumé du livre.
  /// [jacketPath] : Chemin vers la couverture du livre.
  Livre({int? idLivre, required String nomLivre, required Auteur auteur, required String resume, required String? jacketPath})
      : _idLivre = idLivre,
        _nomLivre = nomLivre,
        _auteur = auteur,
        _resume = resume,
        _jacketPath = jacketPath;

  /// Retourne l'identifiant unique du livre.
  int? get idLivre => _idLivre;

  /// Retourne le nom du livre.
  String get nomLivre => _nomLivre;

  /// Retourne l'auteur du livre.
  Auteur get auteur => _auteur;

  /// Retourne le nom de l'auteur.
  String get nomAuteur => _auteur.nomAuteur;

  /// Retourne le résumé du livre.
  String get resume => _resume;

  /// Retourne le chemin vers la couverture du livre.
  String? get jacketPath => _jacketPath;

  /// Définit le nom du livre.
  ///
  /// Lance une [ArgumentError] si le nom du livre est vide.
  set nomLivre(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Le nom du livre ne peut pas être vide');
    }
    _nomLivre = value;
  }

  /// Définit le chemin vers la couverture du livre.
  set jacketPath(String? value) {
    _jacketPath = value;
  }

  /// Convertit un objet [Livre] en [Map].
  ///
  /// Utilisé pour l'insertion en base de données.
  Map<String, dynamic> toMap() {
    return {
      'idLivre': _idLivre,
      'idAuteur': _auteur.idAuteur, /// On stocke l'ID de l'auteur.
      'nomLivre': _nomLivre,
      'resume': _resume,
      'jacket': _jacketPath,
    };
  }

  /// Crée un objet [Livre] à partir d'une [Map].
  ///
  /// Utilisé pour la récupération depuis la base de données.
  factory Livre.fromMap(Map<String, dynamic> map, Auteur auteur) {
    return Livre(
      idLivre: map['idLivre'],
      auteur: auteur, /// Un seul auteur.
      nomLivre: map['nomLivre'] ?? '',
      resume: map['resume'] ?? "",
      jacketPath: map['jacket'],
    );
  }
}
