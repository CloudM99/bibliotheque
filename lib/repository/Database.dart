import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

/// Classe pour gérer la connexion à la base de données SQLite.
class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Database? _database;

  /// Constructeur privé pour le singleton.
  DatabaseClient._internal();

  /// Factory constructor pour obtenir l'instance unique de DatabaseClient.
  factory DatabaseClient() {
    return _instance;
  }

  /// Getter pour obtenir l'instance de la base de données.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données.
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bibliotheque.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Méthode appelée lors de la création de la base de données.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE AUTEUR(
        idAuteur INTEGER PRIMARY KEY AUTOINCREMENT,
        nomAuteur TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE LIVRE (
        idLivre INTEGER PRIMARY KEY AUTOINCREMENT,
        nomLivre TEXT,
        idAuteur INTEGER,
        resume TEXT,
        jacketPath TEXT,
        FOREIGN KEY(idAuteur) REFERENCES AUTEUR(idAuteur)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS USERS(
        idUser INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL,
        prenomUser TEXT NOT NULL,
        loginUser TEXT NOT NULL UNIQUE,
        mdpUser TEXT NOT NULL,
        roleUser TEXT NOT NULL
      )
    ''');

    String hashedAdminPassword = BCrypt.hashpw('admin', BCrypt.gensalt());
    String hashedUserPassword = BCrypt.hashpw('user', BCrypt.gensalt());

    await db.insert('USERS', {
      'userName': 'Admin',
      'prenomUser': 'Administrateur',
      'loginUser': 'admin',
      'mdpUser': hashedAdminPassword,
      'roleUser': 'admin',
    });

    await db.insert('USERS', {
      'userName': 'User',
      'prenomUser': 'Utilisateur',
      'loginUser': 'user',
      'mdpUser': hashedUserPassword,
      'roleUser': 'user',
    });
  }

  /// Méthode appelée lors de la mise à jour de la base de données.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE LIVRE ADD COLUMN jacket TEXT;
    ''');
      await db.execute('''
      ALTER TABLE LIVRE ADD COLUMN resume TEXT;
    ''');
    }
  }
}
