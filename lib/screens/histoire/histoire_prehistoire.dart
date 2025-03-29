import 'package:flutter/material.dart';

class HistoireRegion extends StatelessWidget {
  const HistoireRegion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préhistoire et Antiquité"),
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
                  "Le Rif, région située au nord du Maroc, a été occupé depuis la préhistoire, comme le prouvent les vestiges retrouvés dans plusieurs grottes de la région. Ces traces témoignent d'une présence humaine ancienne, et confirment l'importance historique de cette zone.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Les Phéniciens, grands navigateurs et commerçants de l'Antiquité, ont établi des comptoirs commerciaux le long des côtes rifaines. Ils ont notamment fondé des colonies à Lixus et Rusadir (aujourd'hui Melilla), favorisant les échanges avec le reste du monde méditerranéen.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Sous la domination romaine, la région du Rif est restée en grande partie insoumise. Les tribus berbères, connues pour leur bravoure, ont résisté farouchement à l'influence de Rome. Malgré cette résistance, des échanges commerciaux avec l'Empire romain ont eu lieu, notamment via les routes maritimes qui reliaient la région à d'autres parties de l'Empire.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
          
                Image.asset("assets/histoireRif/prehistoire.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
