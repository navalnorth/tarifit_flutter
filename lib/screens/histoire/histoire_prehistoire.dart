import 'package:flutter/material.dart';
import 'package:tarifitino/widgets/app_strings.dart';

class HistirePre extends StatelessWidget {
  const HistirePre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HistoireStrings.preTitle),
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
                Text( HistoireStrings.preText1, style: Theme.of(context).textTheme.bodyLarge ),
                const SizedBox(height: 16),
                Text( HistoireStrings.preText2, style: Theme.of(context).textTheme.bodyLarge ),
                const SizedBox(height: 16),
                Text( HistoireStrings.preText3, style: Theme.of(context).textTheme.bodyLarge ),
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
