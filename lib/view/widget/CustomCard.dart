import 'dart:io';
import 'package:flutter/material.dart';

/// Widget pour afficher une carte personnalisée.
class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? jacketPath;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String? userRole;
  final bool displayJacket;
  final Widget? trailing;

  /// Constructeur de la carte personnalisée.
  ///
  /// [title] : Titre de la carte.
  /// [subtitle] : Sous-titre de la carte.
  /// [jacketPath] : Chemin vers l'image de la jaquette.
  /// [onTap] : Callback pour l'action lors du tap.
  /// [onDelete] : Callback pour l'action de suppression.
  /// [userRole] : Rôle de l'utilisateur.
  /// [displayJacket] : Indique si la jaquette doit être affichée.
  /// [trailing] : Widget à afficher à la fin de la carte.
  CustomCard({
    required this.title,
    this.subtitle,
    this.jacketPath,
    this.userRole,
    this.displayJacket = false,
    this.onDelete,
    this.onTap,
    this.trailing, Row? actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: displayJacket && jacketPath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(jacketPath!),
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              );
            },
          ),
        )
            : (displayJacket
            ? const Icon(
          Icons.book,
          size: 50,
          color: Colors.white12,
        )
            : null),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        subtitle: Text(subtitle!),
        onTap: () {
          if (userRole == "admin" && onTap != null) {
            onTap!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vous n\'avez pas les droits')),
            );
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userRole == 'admin' && onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.brown),
              ),
          ],
        ),
      ),
    );
  }
}
