import 'package:bibliotheque/view/HomePage.dart';
import 'package:bibliotheque/view/widget/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';
import '../widget/ConfirmDeleteDialog.dart';
import '../widget/CustomCard.dart';

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
    final auteurViewModel = Provider.of<AuteurViewModel>(context, listen: false);

    /// Charger les auteurs lors de l'initialisation de la vue.
    Future.microtask(() => auteurViewModel.chargerAuteurs());

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Auteurs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(userName: userName, userRole: userRole),
              ),
            );
          },
        ),
        actions: [
          if (userRole == 'admin') // Si l'utilisateur est un admin.
            IconButton(
              icon: const Icon(Icons.add),
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
      body: Consumer<AuteurViewModel>(
        builder: (context, auteurViewModel, child) {
          if (auteurViewModel.auteurs.isEmpty) {
            return Center(child: Text('Aucun auteur disponible.'));
          }
          return ListView.builder(
            itemCount: auteurViewModel.auteurs.length,
            itemBuilder: (context, index) {
              final auteur = auteurViewModel.auteurs[index];
              return CustomCard(
                title: auteur.nomAuteur,
                subtitle: 'Détail: ${auteur.detail}',
                trailing: userRole == 'admin'
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifierAuteurView(auteur: auteur),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDeleteDialog(
                            title: 'Confirmer la suppression',
                            content: "Etes-vous sûr de vouloir supprimer l'auteur ?",
                            onConfirm: () {
                              Provider.of<AuteurViewModel>(context, listen: false)
                                  .supprimerAuteur(auteur.idAuteur!);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
