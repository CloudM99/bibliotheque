import 'package:bibliotheque/view/viewAuteur/AjouterAuteurView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../widget/ConfirmDeleteDialog.dart';
import '../widget/CustomCard.dart';
import 'ModifierUserView.dart';
import 'AjouterUserView.dart';
import '../HomePage.dart';

/// Widget pour afficher la liste des utilisateurs.
class UserListView extends StatelessWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la vue pour la liste des utilisateurs.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  const UserListView({super.key, required this.userName, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    // Charger les utilisateurs lors de la construction de la vue.
    if (userViewModel.utilisateurs.isEmpty) {
      Future.microtask(() => userViewModel.chargerUtilisateurs());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des utilisateurs', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(userName: userName, userRole: userRole)),
            );
          },
        ),
        actions: [
          if (userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterUserView()),
                );
              },
            ),
        ],
      ),
      body: userViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userViewModel.utilisateurs.isEmpty
          ? const Center(child: Text('Aucun utilisateur disponible.'))
          : ListView.builder(
        itemCount: userViewModel.utilisateurs.length,
        itemBuilder: (context, index) {
          final user = userViewModel.utilisateurs[index];
          return CustomCard(
            title: user.userName,
            subtitle: user.roleUser,
            userRole: userRole,
            onTap: () {
              if (userRole == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierUserView(user: user),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vous n\'avez pas les permissions suffisantes pour modifier cet utilisateur.')),
                );
              }
            },
            onDelete: () {
              if (userRole == 'admin') {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDeleteDialog(
                    title: 'Supprimer l\'utilisateur',
                    content: 'Voulez-vous vraiment supprimer cet utilisateur ?',
                    onConfirm: () {
                      Provider.of<UserViewModel>(context, listen: false)
                          .supprimerUser(user.idUser!);
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vous n\'avez pas les permissions suffisantes pour supprimer cet utilisateur.')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
