import 'package:bibliotheque/view/widget/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';
import '../widget/ConfirmDeleteDialog.dart';

/// Widget pour afficher la liste des auteurs.
class AuteurListView extends StatelessWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la vue pour la liste des auteurs.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  const AuteurListView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final auteurViewModel = Provider.of<AuteurViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Auteurs'),
        actions: [
          if (userRole == 'admin')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AjouterAuteurView(
                      userName: userName,
                      userRole: userRole,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: auteurViewModel.auteurs.isEmpty
          ? const Center(child: Text('Aucun auteur disponible.'))
          : ListView.builder(
        itemCount: auteurViewModel.auteurs.length,
        itemBuilder: (context, index) {
          final auteur = auteurViewModel.auteurs[index];
          return CustomCard(
            title: auteur.nomAuteur,
            subtitle: 'Détail: ${auteur.detail}',
            userRole: userRole,
            onTap: () {
              if (userRole == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierAuteurView(auteur: auteur),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vous n\'avez pas les permissions suffisantes pour modifier cet auteur.')),
                );
              }
            },
            onDelete: () {
              if (userRole == 'admin') {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDeleteDialog(
                    title: 'Supprimer l\'auteur',
                    content: 'Voulez-vous vraiment supprimer cet auteur ?',
                    onConfirm: () {
                      Provider.of<AuteurViewModel>(context, listen: false)
                          .supprimerAuteur(auteur.idAuteur!);
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vous n\'avez pas les permissions suffisantes pour supprimer cet auteur.')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
