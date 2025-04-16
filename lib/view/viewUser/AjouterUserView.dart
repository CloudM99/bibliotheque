import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';

/// Widget pour ajouter un nouvel utilisateur.
class AjouterUserView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _mdpUserController = TextEditingController();
  final List<String> _roles = ['admin', 'user'];

  String? _selectedRole;

  /// Constructeur de la vue pour ajouter un utilisateur.
  AjouterUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un utilisateur', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xCC893F45),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le nom de l'utilisateur.
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Nom de l\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              /// Champ pour le prénom de l'utilisateur.
              TextFormField(
                controller: _prenomUserController,
                decoration: const InputDecoration(labelText: 'Prénom de l\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom d\'utilisateur';
                  }
                  return null;
                },
              ),
              /// Champ pour le login de l'utilisateur.
              TextFormField(
                controller: _loginUserController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un login';
                  }
                  return null;
                },
              ),
              /// Champ pour le mot de passe de l'utilisateur.
              TextFormField(
                controller: _mdpUserController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              /// Sélection du rôle de l'utilisateur.
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Rôle'),
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
              const SizedBox(height: 32),
              /// Bouton pour ajouter l'utilisateur.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<UserViewModel>(context, listen: false).ajouterUser(
                      userName: _userNameController.text,
                      prenomUser: _prenomUserController.text,
                      loginUser: _loginUserController.text,
                      mdpUser: _mdpUserController.text,
                      roleUser: _selectedRole ?? '',
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Ajouter l\'utilisateur', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
