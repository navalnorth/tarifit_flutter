import 'package:flutter/material.dart';

class HistoireMoyen extends StatelessWidget {
  const HistoireMoyen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Le Moyen Âge"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Text(
                  "L'islam pénètre le Rif au VIIIe siècle, apporté par les conquérants arabes. Toutefois, l'arabisation y reste limitée et la culture amazighe domine.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Sous les Almoravides, Almohades et Mérinides, la région oscille entre autonomie et contrôle central. ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Le commerce avec l'Andalousie musulmane est florissant, et les routes caravanières reliant le Maroc aux autres territoires musulmans traversent parfois le Rif.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
          
                Image.asset("assets/histoireRif/moyen.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
