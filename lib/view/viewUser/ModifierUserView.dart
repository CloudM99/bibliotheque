import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/User.dart';

/// Widget pour modifier un utilisateur existant.
class ModifierUserView extends StatelessWidget {
  final User user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _mdpUserController = TextEditingController();
  final List<String> _roles = ['admin', 'user'];
  String? _selectedRole;

  /// Constructeur de la vue pour modifier un utilisateur.
  ///
  /// [user] : L'utilisateur à modifier.
  ModifierUserView({required this.user});

  @override
  Widget build(BuildContext context) {
    // Initialiser les contrôleurs avec les valeurs actuelles de l'utilisateur.
    _userNameController.text = user.userName;
    _prenomUserController.text = user.prenomUser;
    _loginUserController.text = user.loginUser;
    _selectedRole = user.roleUser;

    return Scaffold(
      appBar: AppBar(title: Text("Modifier l'Utilisateur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le nom de l'utilisateur.
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: "Nom de l'utilisateur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom d'utilisateur";
                  }
                  return null;
                },
              ),
              /// Champ pour le prénom de l'utilisateur.
              TextFormField(
                controller: _prenomUserController,
                decoration: InputDecoration(labelText: "Prénom de l'utilisateur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un prénom d'utilisateur";
                  }
                  return null;
                },
              ),
              /// Champ pour le login de l'utilisateur.
              TextFormField(
                controller: _loginUserController,
                decoration: InputDecoration(labelText: "Login"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un login";
                  }
                  return null;
                },
              ),
              /// Champ pour le mot de passe de l'utilisateur.
              TextFormField(
                controller: _mdpUserController,
                decoration: InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un mot de passe";
                  }
                  return null;
                },
              ),
              /// Sélection du rôle de l'utilisateur.
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rôle'),
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _selectedRole = newValue;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un rôle';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Bouton pour mettre à jour l'utilisateur.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Mettre à jour l'utilisateur via le ViewModel.
                    Provider.of<UserViewModel>(context, listen: false).mettreAJourUser(
                      user.idUser!,
                      _userNameController.text,
                      _prenomUserController.text,
                      _loginUserController.text,
                      _mdpUserController.text,
                      _selectedRole!,
                    );
                    Navigator.pop(context); // Revenir à la liste des utilisateurs.
                  }
                },
                child: Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
