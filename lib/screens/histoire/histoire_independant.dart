import 'package:flutter/material.dart';
import 'package:tarifitino/widgets/app_strings.dart';

class HistoireIndependant extends StatelessWidget {
  const HistoireIndependant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HistoireStrings.indTitle),
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
                Text( HistoireStrings.indText1, style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text( HistoireStrings.indText2, style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text( HistoireStrings.indText3, style: Theme.of(context).textTheme.bodyLarge,
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
