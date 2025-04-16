import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../HomePage.dart';

/// Widget pour la vue de connexion.
class LoginView extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Constructeur de la vue de connexion.
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xCC893F45),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Champ pour le login.
            TextFormField(
              controller: _loginController,
              decoration: const InputDecoration(labelText: 'Login'),
            ),
            /// Champ pour le mot de passe.
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            /// Bouton pour se connecter.
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await userViewModel.login(
                  _loginController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                } else {
                  final String userName = userViewModel.userName;
                  final String userRole = userViewModel.userRole;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        userName: userName,
                        userRole: userRole,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
