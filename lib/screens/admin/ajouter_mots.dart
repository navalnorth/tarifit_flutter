import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarifitino/screens/admin/admin_panel.dart';

class AjouterMots extends StatefulWidget {
  const AjouterMots({super.key});

  @override
  AjouterMotsState createState() => AjouterMotsState();
}

class AjouterMotsState extends State<AjouterMots> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;

  final TextEditingController _motFrancaisController = TextEditingController();
  final TextEditingController _motRifController = TextEditingController();
  final TextEditingController _newCategorieController = TextEditingController();

  List<String> _categories = [];
  String _selectedCategorie = "";



  Stream<List<String>> _fetchCategories() {
    return FirebaseFirestore.instance.collection("categories_mots").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc["nom"] as String).toList();
    });
  }

  Future<void> _addNewCategorie() async {
    String newCategorie = _newCategorieController.text.trim();
    if (newCategorie.isNotEmpty && !_categories.contains(newCategorie)) {
      await FirebaseFirestore.instance.collection("categories_mots").add({"nom": newCategorie});
      
      setState(() {
        _categories = [..._categories, newCategorie];
        _selectedCategorie = newCategorie;
      });

      _newCategorieController.clear();
    }
  }




  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await Permission.microphone.request();
    await _recorder!.openRecorder();
  }



  Future<void> _startRecording() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    _audioPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enregistrement commencé !")));
  }



  Future<void> _stopRecording() async {
    String? path = await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _audioPath = path;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enregistrement terminé !")));
  }



  Future<String> _uploadAudio(File audioFile) async {
    String fileName = "audios/${DateTime.now().millisecondsSinceEpoch}.aac";
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    await storageRef.putFile(audioFile);
    return await storageRef.getDownloadURL();
  }



  Future<void> _saveWord() async {
    if (_audioPath == null) return;

    File audioFile = File(_audioPath!);
    String audioUrl = await _uploadAudio(audioFile);

    await FirebaseFirestore.instance.collection("mots").add({
      "motFrancais": _motFrancaisController.text,
      "motRif": _motRifController.text,
      "categorie": _selectedCategorie,
      "audioUrl": audioUrl,
    });

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel()));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mot ajouté !")));
  }



  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _motFrancaisController.dispose();
    _motRifController.dispose();
    _newCategorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un mot")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _motFrancaisController, decoration: const InputDecoration(labelText: "Mot en français")),
            TextField(controller: _motRifController, decoration: const InputDecoration(labelText: "Mot en Rif")),
            const SizedBox(height: 20,),

            StreamBuilder<List<String>>(
              stream: _fetchCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) { return const CircularProgressIndicator(); }

                _categories = snapshot.data!;

                // Si _selectedCategorie n'est pas dans la liste des catégories, on met à jour la sélection.
                if (_selectedCategorie.isNotEmpty && !_categories.contains(_selectedCategorie)) {
                  _selectedCategorie = _categories.isNotEmpty ? _categories.first : "";
                }

                return DropdownButtonFormField<String>(
                  value: _categories.contains(_selectedCategorie) ? _selectedCategorie : null,  // Vérification ajoutée
                  decoration: const InputDecoration(labelText: "Catégorie"),
                  items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) => setState(() => _selectedCategorie = val ?? ""),
                );
              },
            ),
            const SizedBox(height: 10,),
            

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCategorieController,
                    decoration: const InputDecoration(labelText: "Nouvelle catégorie"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: _addNewCategorie,
                ),
              ],
            ),
            const SizedBox(height: 20,),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration( shape: BoxShape.circle, color: _isRecording ? Colors.red : Colors.green),
              child: IconButton(
                iconSize: 40,
                icon: Icon( _isRecording ? Icons.stop : Icons.mic, color: Colors.white ),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
            ),
            const SizedBox(height: 50,),

            ElevatedButton(
              onPressed: _saveWord,
              child: const Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }
}