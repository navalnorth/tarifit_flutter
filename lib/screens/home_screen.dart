import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tarifitino/screens/admin/admin_panel.dart';
import 'package:tarifitino/screens/alphabet_screen.dart';
import 'package:tarifitino/screens/histoire_screen.dart';
import 'package:tarifitino/screens/images_screen.dart';
import 'package:tarifitino/screens/list_quiz.dart';
import 'package:tarifitino/screens/mot_screen.dart';
import 'package:tarifitino/screens/phrases_screen.dart';
import 'package:tarifitino/services/ad_banniere.dart';
import 'package:tarifitino/services/firebase_auth_service.dart';
import 'package:tarifitino/widgets/app_strings.dart';
import 'package:tarifitino/widgets/rubrique_board.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;

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
            title: const Text(HomeScreenStrings.connexionRequise),
            content: const Text(HomeScreenStrings.connexionMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(HomeScreenStrings.ok),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination));
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
    // ✅ Charger les bannières pub
    _bannerAdTop = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('Top banner failed to load: $error');
          }
          ad.dispose();
        },
      ),
    )..load();

    _bannerAdBottom = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('Bottom banner failed to load: $error');
          }
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(AppStrings.appTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: _isAdmin
            ? IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminPanel())),
                icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(_currentUser == null ? Icons.person : Icons.logout,
                color: Colors.white),
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
        child: Column(
          children: [
            if (_bannerAdTop != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _bannerAdTop!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdTop!),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RubriqueBoard(
                          text: HomeScreenStrings.motsTraduits,
                          destination: MotScreen(),
                          height: 150,
                          txtsize: 17,
                        ),
                        SizedBox(width: 10),
                        RubriqueBoard(
                          text: HomeScreenStrings.phrases,
                          destination: PhrasesScreen(),
                          height: 150,
                          txtsize: 17,
                          bgcolor: Color.fromARGB(255, 14, 101, 201),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    RubriqueBoard(
                      text: HomeScreenStrings.quiz,
                      height: 150,
                      width: double.infinity,
                      txtsize: 17,
                      iconRubrique: Icons.play_arrow,
                      bgcolor: const Color.fromARGB(255, 8, 180, 94),
                      onTapOverride: () {
                        checkLoginAndNavigate(context, const ListeQuizScreen());
                      },
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RubriqueBoard(
                          text: HomeScreenStrings.imagesRif,
                          destination: ImagesScreen(),
                          height: 150,
                          txtsize: 17,
                          bgcolor: Color.fromARGB(255, 212, 165, 36),
                        ),
                        SizedBox(width: 10),
                        RubriqueBoard(
                          text: HomeScreenStrings.histoireRif,
                          destination: HistoireScreen(),
                          height: 150,
                          txtsize: 17,
                          bgcolor: Color.fromARGB(255, 105, 49, 49),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const RubriqueBoard(
                      text: HomeScreenStrings.alphabetRif,
                      destination: AlphabetScreen(),
                      height: 150,
                      width: double.infinity,
                      txtsize: 17,
                      bgcolor: Color.fromARGB(255, 109, 107, 224),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (_bannerAdBottom != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _bannerAdBottom!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdBottom!),
              ),
          ],
        ),
      ),
    );
  }
}
