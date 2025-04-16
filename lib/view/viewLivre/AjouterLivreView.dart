import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'package:image_picker/image_picker.dart';

/// Widget pour ajouter un nouveau livre.
class AjouterLivreView extends StatelessWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la vue pour ajouter un livre.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  AjouterLivreView({required this.userName, required this.userRole});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomLivreController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  String? _selectedAuteur;
  String? _jacketPath;

  /// Méthode pour sélectionner une image depuis la galerie.
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _jacketPath = image.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuteurViewModel>(context, listen: false).chargerAuteurs();
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un livre')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le titre du livre.
              TextFormField(
                controller: _nomLivreController,
                decoration: InputDecoration(labelText: "Titre du Livre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un titre";
                  }
                  return null;
                },
              ),
              /// Champ pour le résumé du livre.
              TextFormField(
                controller: _resumeController,
                decoration: InputDecoration(labelText: "Résumé du Livre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un résumé";
                  }
                  return null;
                },
              ),
              /// Sélection de l'auteur du livre.
              Consumer<AuteurViewModel>(
                builder: (context, auteurViewModel, child) {
                  final auteurs = auteurViewModel.auteurs;

                  if (auteurs.isEmpty) {
                    return Text("Aucun auteur, veuillez en ajouter un.");
                  }

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Auteur"),
                    items: auteurs.map((auteur) {
                      return DropdownMenuItem<String>(
                        value: auteur.idAuteur.toString(),
                        child: Text(auteur.nomAuteur),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _selectedAuteur = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez sélectionner un auteur";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              /// Bouton pour sélectionner une jaquette.
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Sélectionner une jaquette"),
              ),
              SizedBox(height: 20),
              /// Bouton pour ajouter le livre.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    int? idAuteur = int.tryParse(_selectedAuteur!);
                    if (idAuteur == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Veuillez sélectionner un auteur valide")),
                      );
                      return;
                    }

                    /// Ajouter un livre via le ViewModel.
                    Provider.of<LivreViewModel>(context, listen: false)
                        .ajouterLivre(_nomLivreController.text, idAuteur, _resumeController.text, _jacketPath);
                    Navigator.pop(context); // Revenir à la liste des livres.
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
