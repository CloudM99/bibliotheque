import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Widget pour afficher une boîte de dialogue de confirmation de suppression.
class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  /// Constructeur de la boîte de dialogue de confirmation de suppression.
  ///
  /// [title] : Titre de la boîte de dialogue.
  /// [content] : Contenu de la boîte de dialogue.
  /// [onConfirm] : Callback pour l'action à exécuter.
  ConfirmDeleteDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xCC893F45),
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        /// Bouton NON.
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ferme la boîte de dialogue.
          },
          child: Text('Non'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Color(0xFF7e7978)),
          ),
        ),
        /// Bouton OUI.
        TextButton(
          onPressed: () {
            onConfirm(); // Exécute la fonction en paramètre.
            Navigator.of(context).pop(); // Ferme la boîte de dialogue.
          },
          child: Text('Oui'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ],
    );
  }
}
