import 'package:flutter/material.dart';
import 'package:tarifitino/widgets/carousel.dart'; // Import du composant

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMAGES DU RIF", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              ImageCarousel(title: "Al Hoceima", imagePaths: imagePathsHoceima),
              ImageCarousel(title: "Nador", imagePaths: imagePathsNador),
            ],
          ),
        ),
      ),
    );
  }
}
