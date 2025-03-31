import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class EcouterMots extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  EcouterMots({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des mots")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("mots").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var mots = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: mots.length,
            itemBuilder: (context, index) {
              var mot = mots[index];
              return ListTile(
                title: Text("${mot["motFrancais"]} - ${mot["motRif"]}"),
                subtitle: Text("Catégorie : ${mot["categorie"]}"),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _audioPlayer.play(UrlSource(mot["audioUrl"])), // Correction ici
                ),
              );
            },
          );
        },
      ),
    );
  }
}
