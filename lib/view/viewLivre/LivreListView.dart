import 'package:bibliotheque/view/widget/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../widget/ConfirmDeleteDialog.dart';

/// Widget pour afficher la liste des livres.
class LivreListView extends StatelessWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la vue pour la liste des livres.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  const LivreListView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final livreViewModel = Provider.of<LivreViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres'),
        actions: [
          if (userRole == 'admin')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AjouterLivreView(
                      userName: userName,
                      userRole: userRole,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: livreViewModel.livres.isEmpty
          ? const Center(child: Text('Aucun livre disponible.'))
          : ListView.builder(
        itemCount: livreViewModel.livres.length,
        itemBuilder: (context, index) {
          final livre = livreViewModel.livres[index];
          return CustomCard(
            title: livre.nomLivre,
            subtitle: 'Auteur: ${livre.nomAuteur}, Résumé : ${livre.resume}',
            jacketPath: livre.jacketPath,
            displayJacket: true,
            userRole: userRole,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModifierLivreView(livre: livre),
                ),
              );
            },
            onDelete: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmDeleteDialog(
                  title: 'Supprimer le livre',
                  content: 'Voulez-vous vraiment supprimer ce livre ?',
                  onConfirm: () {
                    Provider.of<LivreViewModel>(context, listen: false)
                        .supprimerLivre(livre.idLivre!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
