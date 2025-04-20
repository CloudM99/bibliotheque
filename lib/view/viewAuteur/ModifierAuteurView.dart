import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart';

/// Widget pour modifier un auteur existant.
class ModifierAuteurView extends StatefulWidget {
  final Auteur auteur;

  /// Constructeur de la vue pour modifier un auteur.
  ///
  /// [auteur] : L'auteur à modifier.
  ModifierAuteurView({required this.auteur});

  @override
  _ModifierAuteurViewState createState() => _ModifierAuteurViewState();
}

class _ModifierAuteurViewState extends State<ModifierAuteurView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs actuelles de l'auteur.
    _nomAuteurController.text = widget.auteur.nomAuteur;
    _detailController.text = widget.auteur.detail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier l'Auteur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Champ pour le nom de l'auteur.
              TextFormField(
                controller: _nomAuteurController,
                decoration: InputDecoration(labelText: "Nom de l'Auteur"),
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
                decoration: InputDecoration(labelText: "Détail de l'Auteur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un détail pour l'auteur";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              /// Bouton pour mettre à jour l'auteur.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    /// Mettre à jour l'auteur via le ViewModel avec le détail mis à jour.
                    Provider.of<AuteurViewModel>(context, listen: false)
                        .mettreAJourAuteur(widget.auteur.idAuteur!, _nomAuteurController.text, _detailController.text);
                    Navigator.pop(context); // Revenir à la liste des auteurs.
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
