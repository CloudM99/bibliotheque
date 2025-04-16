import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Livre.dart';

/// Widget pour modifier un livre existant.
class ModifierLivreView extends StatelessWidget {
  final Livre livre;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomLivreController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  String? _selectedAuteur;
  String? _jacketPath;

  /// Constructeur de la vue pour modifier un livre.
  ///
  /// [livre] : Le livre à modifier.
  ModifierLivreView({required this.livre}) {
    _nomLivreController.text = livre.nomLivre;
    _resumeController.text = livre.resume;
    _selectedAuteur = livre.auteur.idAuteur.toString();
    _jacketPath = livre.jacketPath;
  }

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
      appBar: AppBar(title: Text("Modifier le livre")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le titre du livre.
              TextFormField(
                controller: _nomLivreController,
                decoration: InputDecoration(labelText: "Titre du livre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le titre";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Champ pour la description du livre.
              TextFormField(
                controller: _resumeController,
                decoration: InputDecoration(labelText: "Description du livre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Sélection de l'auteur du livre.
              Consumer<AuteurViewModel>(
                builder: (context, auteurViewModel, child) {
                  final auteurs = auteurViewModel.auteurs;

                  if (auteurs.isEmpty) {
                    return Text("Aucun Auteur, veuillez en ajouter un.");
                  }

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Auteur"),
                    value: _selectedAuteur,
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
              /// Bouton pour mettre à jour le livre.
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

                    /// Mettre à jour le livre via le ViewModel.
                    Provider.of<LivreViewModel>(context, listen: false)
                        .mettreAJourLivre(livre.idLivre!, _nomLivreController.text, idAuteur, _resumeController.text, _jacketPath);

                    Navigator.pop(context); // Revenir à la liste des livres.
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
