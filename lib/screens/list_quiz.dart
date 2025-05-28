import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarifitino/services/ad_banniere.dart';
import 'package:tarifitino/services/native_ad_widget.dart'; // Ajout pour native ad
import 'quiz_screen.dart';

class ListeQuizScreen extends StatefulWidget {
  const ListeQuizScreen({super.key});

  @override
  State<ListeQuizScreen> createState() => _ListeQuizScreenState();
}

class _ListeQuizScreenState extends State<ListeQuizScreen> {
  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;
  bool _adShown = false;

  @override
  void initState() {
    super.initState();

    _bannerAdTop = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Top banner failed to load: $error');
        },
      ),
    )..load();

    _bannerAdBottom = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Bottom banner failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_adShown) {
      Future.delayed(Duration.zero, () {
        _showNativeAdPopup();
        _adShown = true;
      });
    }
  }

  void _showNativeAdPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const NativeAdWidget(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisis un Quiz")),
      body: Column(
        children: [
          if (_bannerAdTop != null)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: _bannerAdTop!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAdTop!),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("quiz").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final quizDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: quizDocs.length,
                  itemBuilder: (context, index) {
                    final quiz = quizDocs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(quiz["titre"]),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(quizData: quiz),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
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
    );
  }
}
