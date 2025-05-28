import 'package:flutter/material.dart';
import 'package:tarifitino/widgets/app_strings.dart';
import 'package:tarifitino/widgets/carousel.dart';
import 'package:tarifitino/services/native_ad_widget.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  bool _adShown = false;

  final List<String> imagePathsHoceima = const [
    'assets/imagesRif/hoceima/hoceima1.jpg',
    'assets/imagesRif/hoceima/hoceima2.jpg',
    'assets/imagesRif/hoceima/hoceima3.jpg',
    'assets/imagesRif/hoceima/hoceima4.jpg',
    'assets/imagesRif/hoceima/hoceima5.jpg',
  ];

  final List<String> imagePathsNador = const [
    'assets/imagesRif/nador/nador1.jpg',
    'assets/imagesRif/nador/nador2.jpg',
    'assets/imagesRif/nador/nador3.jpg',
    'assets/imagesRif/nador/nador4.jpg',
    'assets/imagesRif/nador/nador5.jpg',
  ];

  final List<String> imagePathsImzouren = const [
    'assets/imagesRif/imzouren/imzouren1.jpg',
    'assets/imagesRif/imzouren/imzouren2.jpg',
    'assets/imagesRif/imzouren/imzouren3.png',
    'assets/imagesRif/imzouren/imzouren4.jpg',
    'assets/imagesRif/imzouren/imzouren5.jpg',
  ];

  final List<String> imagePathsTarguist = const [
    'assets/imagesRif/targuist/targuist1.jpg',
    'assets/imagesRif/targuist/targuist2.jpg',
    'assets/imagesRif/targuist/targuist3.jpeg',
    'assets/imagesRif/targuist/targuist4.jpg',
    'assets/imagesRif/targuist/targuist5.jpg',
  ];

  final List<String> imagePathsMelilla = const [
    'assets/imagesRif/melilla/melilla1.jpg',
    'assets/imagesRif/melilla/melilla2.jpg',
    'assets/imagesRif/melilla/melilla3.jpg',
    'assets/imagesRif/melilla/melilla4.jpg',
    'assets/imagesRif/melilla/melilla5.jpg',
  ];

  final List<String> imagePathsMontagne = const [
    'assets/imagesRif/montagne/montagne1.jpg',
    'assets/imagesRif/montagne/montagne2.jpg',
    'assets/imagesRif/montagne/montagne3.jpg',
    'assets/imagesRif/montagne/montagne4.jpg',
    'assets/imagesRif/montagne/montagne5.jpg',
  ];

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
      appBar: AppBar(
        title: const Text(ImagesRifStrings.title),
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 212, 165, 36),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                ImageCarousel(title: ImagesRifStrings.hoceima, imagePaths: imagePathsHoceima),
                ImageCarousel(title: ImagesRifStrings.nador, imagePaths: imagePathsNador),
                ImageCarousel(title: ImagesRifStrings.imzouren, imagePaths: imagePathsImzouren),
                ImageCarousel(title: ImagesRifStrings.targuist, imagePaths: imagePathsTarguist),
                ImageCarousel(title: ImagesRifStrings.melilla, imagePaths: imagePathsMelilla),
                ImageCarousel(title: ImagesRifStrings.montagne, imagePaths: imagePathsMontagne),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
