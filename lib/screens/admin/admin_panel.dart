import 'package:flutter/material.dart';
import 'package:tarifitino/screens/admin/ajouter_mots.dart';
import 'package:tarifitino/screens/admin/ecouter_mots.dart';
import 'package:tarifitino/widgets/rubrique_board.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RubriqueBoard(
                      text: "Ajouter mots", 
                      destination: AjouterMots(),
                      height: 150,
                      txtsize: 17,
                    ),
                    const SizedBox(width: 10),

                    RubriqueBoard(
                      text: "Ecouter mots", 
                      destination: EcouterMots(),
                      height: 150,
                      txtsize: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
