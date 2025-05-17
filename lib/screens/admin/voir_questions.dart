import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoirQuestions extends StatelessWidget {
  final QueryDocumentSnapshot quizData;

  const VoirQuestions({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
    List questions = quizData["questions"];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz : ${quizData['titre']}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          var question = questions[index];
          List reponses = question["reponses"];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Q${index + 1}: ${question['texte']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (question['audioUrl'] != null)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => AudioPlayer().play(UrlSource(question['audioUrl'])),
                    ),
                  const SizedBox(height: 10),
                  ...reponses.map((rep) => ReponseTile(rep)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReponseTile extends StatefulWidget {
  final dynamic rep;

  const ReponseTile(this.rep, {super.key});

  @override
  State<ReponseTile> createState() => _ReponseTileState();
}

class _ReponseTileState extends State<ReponseTile> {
  bool _isPlaying = false;
  final AudioPlayer _player = AudioPlayer();

  void _play() async {
    setState(() => _isPlaying = true);
    await _player.play(UrlSource(widget.rep['audioUrl']));
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
      title: Text(widget.rep['texte']),
      subtitle: widget.rep['estCorrecte'] == true ? const Text("Bonne réponse", style: TextStyle(color: Colors.green)) : null,
      onTap: _play,
    );
  }
}
