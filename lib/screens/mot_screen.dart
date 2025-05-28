import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarifitino/services/ad_banniere.dart';
import 'package:tarifitino/services/native_ad_widget.dart'; // Ajouté

class MotScreen extends StatefulWidget {
  const MotScreen({super.key});

  @override
  State<MotScreen> createState() => _MotScreenState();
}

class _MotScreenState extends State<MotScreen> {
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
          if (kDebugMode) print('Top banner failed to load: $error');
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
          if (kDebugMode) print('Bottom banner failed to load: $error');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des mots")),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories_mots').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var categories = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        var categorie = categories[index];
                        return CategorySection(categoryName: categorie["nom"]);
                      },
                    );
                  },
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

class CategorySection extends StatelessWidget {
  final String categoryName;

  const CategorySection({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('mots')
              .where("categorie", isEqualTo: categoryName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var mots = snapshot.data!.docs;
            return SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mots.map((mot) {
                    return MotCard(
                      motFrancais: mot["motFrancais"],
                      motRif: mot["motRif"],
                      audioUrl: mot["audioUrl"],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MotCard extends StatefulWidget {
  final String motFrancais;
  final String motRif;
  final String audioUrl;

  const MotCard({
    super.key,
    required this.motFrancais,
    required this.motRif,
    required this.audioUrl,
  });

  @override
  State<MotCard> createState() => _MotCardState();
}

class _MotCardState extends State<MotCard> {
  bool _isPlaying = false;
  final AudioPlayer _player = AudioPlayer();

  void _playAudio() async {
    setState(() => _isPlaying = true);
    await _player.play(UrlSource(widget.audioUrl));
    _player.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAudio,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 53, 172, 177)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.motFrancais, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.motRif, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),
            Icon(Icons.volume_up, color: _isPlaying ? Colors.red : Colors.blue),
          ],
        ),
      ),
    );
  }
}
