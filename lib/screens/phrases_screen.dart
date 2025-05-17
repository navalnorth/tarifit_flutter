import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class PhrasesScreen extends StatefulWidget {
  const PhrasesScreen({super.key});

  @override
  State<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des mots")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categories_phrases').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) { return const Center( child: CircularProgressIndicator()); }
        
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
    );
  }
}

class CategorySection extends StatelessWidget {
  final String categoryName;

  const CategorySection({
    super.key, 
    required this.categoryName
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
          stream: FirebaseFirestore.instance.collection('phrases').where("categorie", isEqualTo: categoryName).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) { return const Center(child: CircularProgressIndicator()); }

            var mots = snapshot.data!.docs;
            return SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mots.map((mot) {
                    return MotCard(
                      motFrancais: mot["phraseFrancais"],
                      motRif: mot["phraseRif"],
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
    required this.audioUrl
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

    // Attendre que le son se termine
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
            BoxShadow( color: Colors.black26, blurRadius: 6, offset: Offset(2, 2) ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( widget.motFrancais, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold) ),
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