/// Classe représentant un auteur.
class Auteur {
  int? _idAuteur = 0;
  String _nomAuteur = '';
  String _detail = '';  /// Champ supplémentaire pour des détails sur l'auteur.

  /// Constructeur de la classe Auteur.
  ///
  /// [idAuteur] : Identifiant unique de l'auteur.
  /// [nomAuteur] : Nom de l'auteur.
  /// [detail] : Détails supplémentaires sur l'auteur.
  Auteur({int? idAuteur, required String nomAuteur, String? detail})
      : _idAuteur = idAuteur,
        _nomAuteur = nomAuteur,
        _detail = detail ?? '';  /// Initialisation avec une valeur par défaut si 'detail' est null.

  /// Retourne l'identifiant unique de l'auteur.
  int? get idAuteur => _idAuteur;

  /// Retourne le nom de l'auteur.
  String get nomAuteur => _nomAuteur;

  /// Retourne les détails supplémentaires sur l'auteur.
  String get detail => _detail;

  /// Définit le nom de l'auteur.
  set nomAuteur(String? nomAuteur) {
    _nomAuteur = nomAuteur!;
  }

  /// Définit les détails supplémentaires sur l'auteur.
  set detail(String? detail) {
    _detail = detail!;
  }

  /// Convertit un objet [Auteur] en [Map].
  ///
  /// Utilisé pour l'insertion en base de données.
  Map<String, dynamic> toMap() {
    return {
      'idAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
      'detail': _detail,
    };
  }

  /// Crée un objet [Auteur] à partir d'une [Map].
  ///
  /// Utilisé pour la récupération depuis la base de données.
  factory Auteur.fromMap(Map<String, dynamic> map) {
    return Auteur(
      idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
      detail: map['detail'] ?? '',  /// Si le détail est null, on le met à une chaîne vide.
    );
  }
}
