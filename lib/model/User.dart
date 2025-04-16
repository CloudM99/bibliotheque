/// Classe représentant un utilisateur.
class User {
  int _idUser;
  String _userName;
  String _prenomUser;
  String _loginUser;
  String _mdpUser;
  String _roleUser;

  /// Constructeur de la classe User.
  ///
  /// [idUser] : Identifiant unique de l'utilisateur.
  /// [userName] : Nom de l'utilisateur.
  /// [prenomUser] : Prénom de l'utilisateur.
  /// [loginUser] : Nom d'utilisateur pour la connexion.
  /// [mdpUser] : Mot de passe de l'utilisateur.
  /// [roleUser] : Rôle de l'utilisateur.
  User({
    required int idUser,
    required String userName,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  })  : _idUser = idUser,
        _userName = userName,
        _prenomUser = prenomUser,
        _loginUser = loginUser,
        _mdpUser = mdpUser,
        _roleUser = roleUser;

  /// Retourne l'identifiant unique de l'utilisateur.
  int get idUser => _idUser;

  /// Retourne le nom de l'utilisateur.
  String get userName => _userName;

  /// Retourne le prénom de l'utilisateur.
  String get prenomUser => _prenomUser;

  /// Retourne le nom d'utilisateur pour la connexion.
  String get loginUser => _loginUser;

  /// Retourne le mot de passe de l'utilisateur.
  String get mdpUser => _mdpUser;

  /// Retourne le rôle de l'utilisateur.
  String get roleUser => _roleUser;

  /// Définit le rôle de l'utilisateur.
  set roleUser(String value) {
    _roleUser = value;
  }

  /// Définit le mot de passe de l'utilisateur.
  set mdpUser(String value) {
    _mdpUser = value;
  }

  /// Définit le nom d'utilisateur pour la connexion.
  set loginUser(String value) {
    _loginUser = value;
  }

  /// Définit le prénom de l'utilisateur.
  set prenomUser(String value) {
    _prenomUser = value;
  }

  /// Définit le nom de l'utilisateur.
  set userName(String value) {
    _userName = value;
  }

  /// Définit l'identifiant unique de l'utilisateur.
  set idUser(int value) {
    _idUser = value;
  }

  /// Convertit un objet [User] en [Map].
  ///
  /// Utilisé pour l'insertion en base de données.
  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'userName': _userName,
      'prenomUser': _prenomUser,
      'loginUser': _loginUser,
      'mdpUser': _mdpUser,
      'roleUser': _roleUser,
    };
  }

  /// Crée un objet [User] à partir d'une [Map].
  ///
  /// Utilisé pour la récupération depuis la base de données.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'],
      userName: map['userName'],
      prenomUser: map['prenomUser'],
      loginUser: map['loginUser'],
      mdpUser: map['mdpUser'],
      roleUser: map['roleUser'],
    );
  }

  /// Surcharge de l'opérateur `==` pour comparer deux objets [User].
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other._idUser == _idUser;
  }

  /// Surcharge de la méthode `hashCode` pour générer un code de hachage basé sur l'ID de l'utilisateur.
  @override
  int get hashCode => _idUser.hashCode;
}