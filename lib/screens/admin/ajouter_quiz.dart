import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReponseData {
  TextEditingController texteController = TextEditingController();
  String? audioPath;
  bool estCorrecte = false;
}

class QuestionData {
  TextEditingController questionController = TextEditingController();
  String? audioPath;
  List<ReponseData> reponses = [
    ReponseData(),
    ReponseData(),
  ];
}

class AjouterQuiz extends StatefulWidget {
  const AjouterQuiz({super.key});

  @override
  State<AjouterQuiz> createState() => _AjouterQuizState();
}

class _AjouterQuizState extends State<AjouterQuiz> {
  final TextEditingController _titreQuizController = TextEditingController();
  final List<QuestionData> _questions = [];

  @override
  void initState() {
    super.initState();
    _questions.add(QuestionData());
  }

  void _ajouterQuestion() {
    setState(() {
      _questions.add(QuestionData());
    });
  }

  void _ajouterReponse(int qIndex) {
    setState(() {
      _questions[qIndex].reponses.add(ReponseData());
    });
  }

  Future<String> _uploadAudio(String localPath) async {
    File file = File(localPath);
    String fileName = 'audios/${DateTime.now().millisecondsSinceEpoch}.aac';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _sauvegarderQuiz() async {
    String titre = _titreQuizController.text.trim();
    if (titre.isEmpty) return;

    List<Map<String, dynamic>> questionsToSave = [];

    for (var question in _questions) {
      String questionTexte = question.questionController.text.trim();
      String? questionAudioUrl;
      if (question.audioPath != null) {
        questionAudioUrl = await _uploadAudio(question.audioPath!);
      }

      List<Map<String, dynamic>> reponsesToSave = [];

      for (var reponse in question.reponses) {
        if (reponse.audioPath == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Toutes les réponses doivent avoir un audio.")));
          return;
        }

        String reponseTexte = reponse.texteController.text.trim();
        String reponseAudioUrl = await _uploadAudio(reponse.audioPath!);

        reponsesToSave.add({
          "texte": reponseTexte,
          "audioUrl": reponseAudioUrl,
          "estCorrecte": reponse.estCorrecte,
        });
      }

      questionsToSave.add({
        "texte": questionTexte,
        "audioUrl": questionAudioUrl,
        "reponses": reponsesToSave,
      });
    }

    await FirebaseFirestore.instance.collection("quiz").add({
      "titre": titre,
      "questions": questionsToSave,
      "date": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quiz ajouté avec succès")));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titreQuizController.dispose();
    for (var q in _questions) {
      q.questionController.dispose();
      for (var r in q.reponses) {
        r.texteController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Ajouter un Quiz")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titreQuizController,
                decoration: const InputDecoration(labelText: "Titre du quiz"),
              ),
              const SizedBox(height: 20),

              ..._questions.asMap().entries.map((qEntry) {
                int qIndex = qEntry.key;
                QuestionData question = qEntry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Question ${qIndex + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: question.questionController,
                      decoration: const InputDecoration(labelText: "Texte de la question"),
                    ),
                    Row(
                      children: [
                        const Text("Audio Question: "),
                        AudioRecorderWidget(
                          onStop: (path) => question.audioPath = path,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...question.reponses.asMap().entries.map((rEntry) {
                      int rIndex = rEntry.key;
                      ReponseData reponse = rEntry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: reponse.texteController,
                              decoration: InputDecoration(labelText: "Réponse ${rIndex + 1}"),
                            ),
                          ),
                          Checkbox(
                            value: reponse.estCorrecte,
                            onChanged: (val) {
                              setState(() {
                                for (var r in question.reponses) {
                                  r.estCorrecte = false;
                                }
                                reponse.estCorrecte = val ?? false;
                              });
                            },
                          ),
                          AudioRecorderWidget(
                            onStop: (path) => reponse.audioPath = path,
                          ),
                        ],
                      );
                    }),
                    TextButton(
                      onPressed: () => _ajouterReponse(qIndex),
                      child: const Text("Ajouter une réponse"),
                    ),
                    const Divider(),
                  ],
                );

              }),
              ElevatedButton(
                onPressed: _ajouterQuestion,
                child: const Text("Ajouter une question"),
              ),
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _sauvegarderQuiz,
                child: const Text("Sauvegarder le quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String path) onStop;
  const AudioRecorderWidget({super.key, required this.onStop});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await Permission.microphone.request();
    await _recorder!.openRecorder();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String path = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(toFile: path);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (path != null) widget.onStop(path);
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
      onPressed: () async {
        if (_isRecording) {
          await _stopRecording();
        } else {
          await _startRecording();
        }
      },
    );
  }
}