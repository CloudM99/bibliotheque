import 'package:bibliotheque/view/viewAuteur/AjouterAuteurView.dart';
import 'package:bibliotheque/viewmodel/viewModelUser/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewAuteur/AuteurListView.dart';
import 'viewLivre/LivreListView.dart';
import 'viewLogin/LoginView.dart';
import 'viewUser/UserListView.dart';
import '../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../view/viewLivre/AjouterLivreView.dart';

/// Widget pour la page d'accueil de l'application.
class HomePage extends StatefulWidget {
  final String userName;
  final String userRole;

  /// Constructeur de la page d'accueil.
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [userRole] : Rôle de l'utilisateur.
  const HomePage({super.key, required this.userName, required this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xCC893F45),
        title: Text("Bibliothèque Numérique"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF893F45),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(userName: widget.userName, userRole: widget.userRole)),
                );
              },
            ),
            if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.book),
                title: Text('Gérer les livres'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LivreListView(userName: widget.userName, userRole: widget.userRole),
                  ));
                },
              ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Gérer les auteurs'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuteurListView(userName: widget.userName, userRole: widget.userRole),
                ));
              },
            ),
            if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.supervised_user_circle_outlined, color: Colors.black),
                title: const Text('Gérer les utilisateurs'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<UserViewModel>(
                      create: (context) => UserViewModel(userName: widget.userName, userRole: widget.userRole),
                      child: UserListView(userName: widget.userName, userRole: widget.userRole),
                    ),
                  ));
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: LivreListView(userName: widget.userName, userRole: widget.userRole)),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Connecté en tant que : ${widget.userName}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<UserViewModel>(context, listen: false).logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xCC893F45),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Déconnexion'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
