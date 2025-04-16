import 'package:bcrypt/bcrypt.dart';
import '../model/User.dart';
import 'Database.dart';

/// Classe pour gérer les opérations CRUD sur la table USERS.
class UserDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Récupérer tous les utilisateurs.
  Future<List<User>> obtenirTousLesUtilisateurs() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query('USERS');

    return result.map((userMap) => User(
      idUser: userMap['idUser'],
      userName: userMap['userName'],
      prenomUser: userMap['prenomUser'],
      loginUser: userMap['loginUser'],
      mdpUser: userMap['mdpUser'],
      roleUser: userMap['roleUser'],
    )).toList();
  }

  /// Ajouter un utilisateur.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [prenomUser] : Prénom de l'utilisateur.
  /// [loginUser] : Nom d'utilisateur pour la connexion.
  /// [mdpUser] : Mot de passe de l'utilisateur.
  /// [roleUser] : Rôle de l'utilisateur.
  Future<int> ajouterUser({
    required String userName,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    final db = await _dbClient.database;
    String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
    return await db.insert('USERS', {
      'userName': userName,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': hashedPassword,
      'roleUser': roleUser,
    });
  }

  /// Mettre à jour un utilisateur.
  ///
  /// [idUser] : Identifiant de l'utilisateur.
  /// [userName] : Nouveau nom de l'utilisateur.
  /// [prenomUser] : Nouveau prénom de l'utilisateur.
  /// [loginUser] : Nouveau nom d'utilisateur pour la connexion.
  /// [mdpUser] : Nouveau mot de passe de l'utilisateur.
  /// [roleUser] : Nouveau rôle de l'utilisateur.
  Future<int> mettreAJourUser(int idUser, String userName, String prenomUser, String loginUser, String mdpUser, String roleUser) async {
    final db = await _dbClient.database;

    Map<String, dynamic> values = {
      'userName': userName,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'roleUser': roleUser,
    };

    if (mdpUser.isNotEmpty) {
      String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
      values['mdpUser'] = hashedPassword;
    }

    return await db.update('USERS', values, where: 'idUser = ?', whereArgs: [idUser]);
  }

  /// Supprimer un utilisateur.
  ///
  /// [idUser] : Identifiant de l'utilisateur à supprimer.
  Future<int> supprimerUtilisateur(int idUser) async {
    final db = await _dbClient.database;
    return await db.delete('USERS', where: 'idUser = ?', whereArgs: [idUser]);
  }

  /// Vérifier les informations de connexion d'un utilisateur.
  ///
  /// [login] : Nom d'utilisateur pour la connexion.
  /// [password] : Mot de passe de l'utilisateur.
  Future<User?> verifierLogin(String login, String password) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query(
      'USERS',
      where: 'loginUser = ?',
      whereArgs: [login],
    );

    if (result.isNotEmpty) {
      final userMap = result.first;
      if (BCrypt.checkpw(password, userMap['mdpUser'])) {
        return User(
          idUser: userMap['idUser'],
          userName: userMap['userName'],
          prenomUser: userMap['prenomUser'],
          loginUser: userMap['loginUser'],
          mdpUser: userMap['mdpUser'],
          roleUser: userMap['roleUser'],
        );
      }
    }
    return null;
  }
}
