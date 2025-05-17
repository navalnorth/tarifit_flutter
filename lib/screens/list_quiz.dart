import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_screen.dart';

class ListeQuizScreen extends StatelessWidget {
  const ListeQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisis un Quiz")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("quiz").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
            
          }

          final quizDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quizDocs.length,
            itemBuilder: (context, index) {
              final quiz = quizDocs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(quiz["titre"]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(quizData: quiz),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
