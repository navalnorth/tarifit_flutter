import 'package:flutter/material.dart';
import 'package:tarifitino/screens/histoire/histoire_colonisation.dart';
import 'package:tarifitino/screens/histoire/histoire_independant.dart';
import 'package:tarifitino/screens/histoire/histoire_moyen.dart';
import 'package:tarifitino/screens/histoire/histoire_prehistoire.dart';
import 'package:tarifitino/screens/histoire/histoire_resistance.dart';
import 'package:tarifitino/widgets/rubrique_board.dart';

class HistoireScreen extends StatelessWidget {
  const HistoireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HISTOIRE DU RIF"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 105, 49, 49),
        centerTitle: true,
      ),

      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RubriqueBoard(
                    text: "Préhistoire et Antiquité",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    width: double.infinity,
                    height: 70,
                    destination: HistoireRegion(),
                    borderColor: Colors.black,
                    iconRubrique: null,
                    txtsize: 20,
                  ),
                  SizedBox(height: 20),
            
                  RubriqueBoard(
                    text: "Moyen Âge",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    width: double.infinity,
                    height: 70,
                    destination: HistoireMoyen(),
                    borderColor: Colors.black,
                    iconRubrique: null,
                    txtsize: 20,
                  ),
                  SizedBox(height: 20),
            
                  RubriqueBoard(
                    text: "Résistance aux influences étrangères",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    width: double.infinity,
                    height: 70,
                    destination: HistoireResistance(),
                    borderColor: Colors.black,
                    iconRubrique: null,
                    txtsize: 20,
                  ),
                  SizedBox(height: 20),
            
                  RubriqueBoard(
                    text: "La colonisation et la guerre du Rif ",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    width: double.infinity,
                    height: 70,
                    destination: HistoireColonisation(),
                    borderColor: Colors.black,
                    iconRubrique: null,
                    txtsize: 20,
                  ),
                  SizedBox(height: 20),
                  RubriqueBoard(
                    text: "Le Rif sous le Maroc indépendant",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    width: double.infinity,
                    height: 70,
                    destination: HistoireIndependant(),
                    borderColor: Colors.black,
                    iconRubrique: null,
                    txtsize: 20,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}