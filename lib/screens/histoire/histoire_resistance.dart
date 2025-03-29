import 'package:flutter/material.dart';

class HistoireResistance extends StatelessWidget {
  const HistoireResistance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résistance aux influences"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Du XVIe au XVIIIe siècle, le Rif reste une zone semi-indépendante, avec des tribus défiant l'autorité des sultans marocains.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "L'Espagne et le Portugal occupent certaines villes côtières comme Ceuta et Melilla, mais les Rifains résistent.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "L'Empire ottoman tente aussi d'influencer la région, sans réel succès. L'économie locale repose sur l'agriculture, le commerce et parfois la piraterie contre les navires européens.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
          
                Image.asset("assets/histoireRif/resistance.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
