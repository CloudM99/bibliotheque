import 'package:bibliotheque/repository/UserDatabase.dart';
import 'package:flutter/widgets.dart';
import '../../model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ViewModel pour gérer les opérations CRUD sur les utilisateurs.
class UserViewModel with ChangeNotifier {
  final UserDatabase _userDatabase = UserDatabase();
  List<User> _utilisateurs = [];
  bool _isLoading = false;
  String _userName;
  String _userRole;

  /// Constructeur du ViewModel pour les utilisateurs.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  UserViewModel({
    required String userName,
    required String userRole,
  }) : _userName = userName,
        _userRole = userRole;

  /// Liste des utilisateurs.
  List<User> get utilisateurs => _utilisateurs;

  /// Indicateur de chargement.
  bool get isLoading => _isLoading;

  /// Nom de l'utilisateur connecté.
  String get userName => _userName;

  /// Rôle de l'utilisateur connecté.
  String get userRole => _userRole;

  /// Récupérer tous les utilisateurs.
  Future<void> chargerUtilisateurs() async {
    _isLoading = true;
    notifyListeners();
    _utilisateurs = await _userDatabase.obtenirTousLesUtilisateurs();
    _isLoading = false;
    notifyListeners();
  }

  /// Ajouter un utilisateur.
  Future<void> ajouterUser({
    required String userName,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDatabase.ajouterUser(
      userName: userName,
      prenomUser: prenomUser,
      loginUser: loginUser,
      mdpUser: mdpUser,
      roleUser: roleUser,
    );
    await chargerUtilisateurs();
  }

  /// Mettre à jour un utilisateur.
  Future<void> mettreAJourUser(
      int idUser,
      String userName,
      String prenomUser,
      String loginUser,
      String mdpUser,
      String roleUser,
      ) async {
    await _userDatabase.mettreAJourUser(
      idUser,
      userName,
      prenomUser,
      loginUser,
      mdpUser,
      roleUser,
    );
    await chargerUtilisateurs();
  }

  /// Supprimer un utilisateur.
  Future<void> supprimerUser(int idUser) async {
    await _userDatabase.supprimerUtilisateur(idUser);
    await chargerUtilisateurs();
  }

  /// Vérifier le login et mettre à jour les informations de l'utilisateur connecté.
  Future<String?> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return 'Veuillez remplir tous les champs';
    }

    var user = await _userDatabase.verifierLogin(login, password);

    if (user != null) {
      _userName = user.userName;
      _userRole = user.roleUser;
      notifyListeners();
      return null;
    } else {
      return 'Login ou mot de passe incorrect.';
    }
  }

  /// Méthode de déconnexion.
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    notifyListeners();
  }
}
