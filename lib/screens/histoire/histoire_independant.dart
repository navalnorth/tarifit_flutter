import 'package:flutter/material.dart';

class HistoireIndependant extends StatelessWidget {
  const HistoireIndependant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("L'après-guerre"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Après l'indépendance du Maroc en 1956, le Rif espère une meilleure intégration, mais il est rapidement marginalisé.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "En 1958-1959, une révolte éclate contre le pouvoir central, qui y répond par une répression brutale sous Hassan II.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Cette marginalisation économique pousse de nombreux Rifains à émigrer, notamment vers l'Europe, formant d'importantes communautés en Espagne, aux Pays-Bas et en Belgique.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
          
                Image.asset("assets/histoireRif/independant.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
