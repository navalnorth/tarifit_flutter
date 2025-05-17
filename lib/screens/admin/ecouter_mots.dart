import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class EcouterMots extends StatefulWidget {
  const EcouterMots({super.key});

  @override
  State<EcouterMots> createState() => _EcouterMotsState();
}

class _EcouterMotsState extends State<EcouterMots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des mots")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categories_mots').snapshots(),
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
          stream: FirebaseFirestore.instance.collection('mots').where("categorie", isEqualTo: categoryName).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) { return const Center(child: CircularProgressIndicator()); }

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

  void _confirmDelete() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le mot"),
        content: const Text("Es-tu sûr de vouloir supprimer ce mot ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Supprimer")),
        ],
      ),
    );

    if (confirm == true) {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection("mots").where("motFrancais", isEqualTo: widget.motFrancais).where("motRif", isEqualTo: widget.motRif).where("audioUrl", isEqualTo: widget.audioUrl).get();

      for (var doc in snap.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mot supprimé !")));
      }
    }
  }

  void _showEditDialog() {
    TextEditingController motFrancaisController = TextEditingController(text: widget.motFrancais);
    TextEditingController motRifController = TextEditingController(text: widget.motRif);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier le mot"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: motFrancaisController,
                decoration: const InputDecoration(labelText: "Mot en français"),
              ),
              TextField(
                controller: motRifController,
                decoration: const InputDecoration(labelText: "Mot en rifain"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                String nouveauFrancais = motFrancaisController.text.trim();
                String nouveauRif = motRifController.text.trim();

                if (nouveauFrancais.isNotEmpty && nouveauRif.isNotEmpty) {
                  // Chercher le mot exact dans Firestore
                  QuerySnapshot snap = await FirebaseFirestore.instance.collection("mots").where("motFrancais", isEqualTo: widget.motFrancais).where("motRif", isEqualTo: widget.motRif).where("audioUrl", isEqualTo: widget.audioUrl).get();

                  for (var doc in snap.docs) {
                    await doc.reference.update({
                      "motFrancais": nouveauFrancais,
                      "motRif": nouveauRif,
                    });
                  }

                  if (!mounted) return; 
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _playAudio,
          onLongPress: _confirmDelete,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 53, 172, 177)),
                  boxShadow: const [ BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)) ],
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
              const SizedBox(height: 8),
            ],
          ),
        ),

        GestureDetector(
          onTap: _showEditDialog,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromARGB(255, 53, 172, 177)),
              boxShadow: const [ BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)) ],
            ),
            child: const Text("Modifier"),
          ),
        )
      ],
    );
  }
}