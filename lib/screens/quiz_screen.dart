import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  final QueryDocumentSnapshot quizData;

  const QuizScreen({super.key, required this.quizData});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedIndex;

  AudioPlayer player = AudioPlayer();

  List get questions => widget.quizData["questions"];

  void _playAudio(String url) async {
    await player.stop(); // Stop previous
    await player.play(UrlSource(url));
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedIndex = index;

      if (questions[_currentIndex]['reponses'][index]['estCorrecte'] == true) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedIndex = null;
      });
    } else {
      _saveScore();
      _showResult();
    }
  }

  void _saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("resultats_quiz").add({
      "quizId": widget.quizData.id,
      "titreQuiz": widget.quizData["titre"],
      "userId": user.uid,
      "score": _score,
      "total": questions.length,
      "date": FieldValue.serverTimestamp(),
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz terminé"),
        content: Text("Ton score: $_score / ${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var question = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Question ${_currentIndex + 1} / ${questions.length}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question["texte"], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (question["audioUrl"] != null)
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => _playAudio(question["audioUrl"]),
              ),
            const SizedBox(height: 20),
            ...List.generate(question["reponses"].length, (index) {
              var rep = question["reponses"][index];
              Color? color;

              if (_answered) {
                if (rep["estCorrecte"]) {
                  color = Colors.green;
                } else if (_selectedIndex == index) {
                  color = Colors.red;
                } else {
                  color = Colors.grey.shade200;
                }
              }

              return Card(
                color: color,
                child: ListTile(
                  title: Text(rep["texte"]),
                  leading: const Icon(Icons.volume_up),
                  onTap: () {
                    _playAudio(rep["audioUrl"]);
                    _selectAnswer(index);
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(_currentIndex < questions.length - 1 ? "Suivant" : "Voir le score"),
              )
          ],
        ),
      ),
    );
  }
}