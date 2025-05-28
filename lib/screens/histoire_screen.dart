import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarifitino/services/ad_banniere.dart';
import 'package:tarifitino/services/native_ad_widget.dart'; // Ajout pour native ad
import 'package:tarifitino/screens/histoire/histoire_colonisation.dart';
import 'package:tarifitino/screens/histoire/histoire_independant.dart';
import 'package:tarifitino/screens/histoire/histoire_moyen.dart';
import 'package:tarifitino/screens/histoire/histoire_prehistoire.dart';
import 'package:tarifitino/screens/histoire/histoire_resistance.dart';
import 'package:tarifitino/widgets/app_strings.dart';
import 'package:tarifitino/widgets/rubrique_board.dart';

class HistoireScreen extends StatefulWidget {
  const HistoireScreen({super.key});

  @override
  State<HistoireScreen> createState() => _HistoireScreenState();
}

class _HistoireScreenState extends State<HistoireScreen> {
  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;
  bool _adShown = false;

  @override
  void initState() {
    super.initState();

    _bannerAdTop = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('Top banner failed: $error');
          }
          ad.dispose();
        },
      ),
    )..load();

    _bannerAdBottom = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('Bottom banner failed: $error');
          }
          ad.dispose();
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
      appBar: AppBar(
        title: const Text("HISTOIRE DU RIF"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 105, 49, 49),
        centerTitle: true,
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RubriqueBoard(
                          text: HistoireStrings.pre,
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                          width: double.infinity,
                          height: 70,
                          destination: HistirePre(),
                          borderColor: Colors.black,
                          iconRubrique: null,
                          txtsize: 20,
                        ),
                        SizedBox(height: 20),
                        RubriqueBoard(
                          text: HistoireStrings.moyen,
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                          width: double.infinity,
                          height: 70,
                          destination: HistoireMoyen(),
                          borderColor: Colors.black,
                          iconRubrique: null,
                          txtsize: 20,
                        ),
                        SizedBox(height: 20),
                        RubriqueBoard(
                          text: HistoireStrings.res,
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                          width: double.infinity,
                          height: 70,
                          destination: HistoireResistance(),
                          borderColor: Colors.black,
                          iconRubrique: null,
                          txtsize: 20,
                        ),
                        SizedBox(height: 20),
                        RubriqueBoard(
                          text: HistoireStrings.col,
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                          width: double.infinity,
                          height: 70,
                          destination: HistoireColonisation(),
                          borderColor: Colors.black,
                          iconRubrique: null,
                          txtsize: 20,
                        ),
                        SizedBox(height: 20),
                        RubriqueBoard(
                          text: HistoireStrings.ind,
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                          width: double.infinity,
                          height: 70,
                          destination: HistoireIndependant(),
                          borderColor: Colors.black,
                          iconRubrique: null,
                          txtsize: 20,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
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
