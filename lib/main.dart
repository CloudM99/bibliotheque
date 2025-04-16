import 'package:bibliotheque/viewmodel/viewModelUser/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'viewmodel/viewModelLivre/LivreViewModel.dart';
import 'view/HomePage.dart';
import 'view/viewLogin/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Fonction principale pour démarrer l'application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuteurViewModel()),
        ChangeNotifierProvider(create: (_) => LivreViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel(userName: '', userRole: '')),
      ],
      child: MyApp(),
    ),
  );
}

/// Widget principal de l'application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bibliothèque Numérique",
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: LoginView(),
      routes: {
        '/home': (context) => HomePage(userName: '', userRole: ''),
      },
    );
  }
}
