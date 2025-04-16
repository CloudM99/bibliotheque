import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';

/// Widget pour ajouter un nouvel auteur.
class AjouterAuteurView extends StatelessWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la vue pour ajouter un auteur.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  AjouterAuteurView({required this.userName, required this.userRole});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un auteur')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le nom de l'auteur.
              TextFormField(
                controller: _nomAuteurController,
                decoration: InputDecoration(labelText: "Nom de l'auteur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom d'auteur";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Champ pour le détail de l'auteur.
              TextFormField(
                controller: _detailController,
                decoration: InputDecoration(labelText: "Détail de l'auteur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un détail pour l'auteur";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Bouton pour ajouter l'auteur.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    /// Ajouter un auteur via le ViewModel, incluant le détail.
                    Provider.of<AuteurViewModel>(context, listen: false)
                        .ajouterAuteur(_nomAuteurController.text, _detailController.text);
                    Navigator.pop(context); // Revenir à la liste des auteurs.
                  }
                },
                child: Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
