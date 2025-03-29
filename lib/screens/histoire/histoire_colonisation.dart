import 'package:flutter/material.dart';

class HistoireColonisation extends StatelessWidget {
  const HistoireColonisation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Colonisation et guerre du Rif"),
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
                  "Avec le Traité de Fès en 1912, le Maroc est divisé entre un protectorat français et une zone espagnole incluant le Rif.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Les Rifains refusent cette occupation et mènent une résistance acharnée sous la direction d'Abdelkrim El Khattabi.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Il proclame la République du Rif en 1921, mais celle-ci est écrasée en 1926 après une violente répression franco-espagnole, incluant l'utilisation de gaz toxiques. Abdelkrim est exilé et la région subit une forte répression.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
          
                Image.asset("assets/histoireRif/colonisation.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
