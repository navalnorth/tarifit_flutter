import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'voir_questions.dart';

class EcouterQuiz extends StatefulWidget {
  const EcouterQuiz({super.key});

  @override
  State<EcouterQuiz> createState() => _EcouterQuizState();
}

class _EcouterQuizState extends State<EcouterQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz').orderBy("date", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            var quizList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: quizList.length,
              itemBuilder: (context, index) {
                var quiz = quizList[index];

                return Dismissible(
                  key: Key(quiz.id),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmer la suppression"),
                        content: Text("Voulez-vous supprimer le quiz « ${quiz['titre']} » ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    var scaf = ScaffoldMessenger.of(context);
                    await FirebaseFirestore.instance.collection('quiz').doc(quiz.id).delete();
                    if (!mounted) return;
                    scaf.showSnackBar(SnackBar(content: Text("Quiz « ${quiz['titre']} » supprimé")));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        quiz['titre'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Questions: ${quiz['questions'].length}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VoirQuestions(quizData: quiz),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
