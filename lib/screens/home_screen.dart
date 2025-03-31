import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tarifitino/screens/admin/admin_panel.dart';
import 'package:tarifitino/screens/alphabet_screen.dart';
import 'package:tarifitino/screens/histoire_screen.dart';
import 'package:tarifitino/screens/images_screen.dart';
import 'package:tarifitino/screens/mot_screen.dart';
import 'package:tarifitino/screens/quiz_screen.dart';
import 'package:tarifitino/services/firebase_auth_service.dart';
import 'package:tarifitino/widgets/rubrique_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isAdmin = true;



  Future<void> _checkUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _isAdmin = userDoc.get('role') == 'admin';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du rôle: $e");
      }
    }
  }

  void checkLoginAndNavigate(BuildContext context, Widget destination) {
    if (_currentUser == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Connexion requise"),
            content: const Text("Connectez-vous avec Google pour accéder à cette section."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
    }
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
        _isAdmin = false;
      });

      if (user != null) {
        _checkUserRole(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TARIFITINO", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: _isAdmin 
          ? IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel())), 
              icon: const Icon(Icons.admin_panel_settings, color: Colors.white)
            ) 
          : null
          ,
        actions: [
          IconButton(
            icon: Icon(
              _currentUser == null ? Icons.person : Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_currentUser == null) {
                await _authService.signInWithGoogle();
              } else {
                await _authService.signOut();
              }
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RubriqueBoard(
                      text: "Mots Traduits", 
                      destination: MotScreen(),
                      height: 150,
                      txtsize: 17,
                    ),
                    SizedBox(width: 10),

                    RubriqueBoard(
                      text: "Conversations", 
                      destination: MotScreen(),
                      height: 150,
                      txtsize: 17,
                      bgcolor: Color.fromARGB(255, 14, 101, 201),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                RubriqueBoard(
                  text: "Quiz",
                  height: 150,
                  width: double.infinity,
                  txtsize: 17,
                  iconRubrique: Icons.play_arrow,
                  bgcolor: const Color.fromARGB(255, 8, 180, 94),
                  onTapOverride: () {
                    checkLoginAndNavigate(context, const QuizScreen());
                  },
                ),
                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RubriqueBoard(
                      text: "Images du Rif", 
                      destination: ImagesScreen(),
                      height: 150,
                      txtsize: 17,
                      bgcolor: Color.fromARGB(255, 212, 165, 36),
                    ),
                    SizedBox(width: 10),

                    RubriqueBoard(
                      text: "Histoire du Rif", 
                      destination: HistoireScreen(),
                      height: 150,
                      txtsize: 17,
                      bgcolor: Color.fromARGB(255, 105, 49, 49),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                const RubriqueBoard(
                  text: "Alphabet Rif", 
                  destination: AlphabetScreen(),
                  height: 150,
                  width: double.infinity,
                  txtsize: 17,
                  bgcolor: Color.fromARGB(255, 109, 107, 224),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
