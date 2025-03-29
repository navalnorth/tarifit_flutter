import 'package:flutter/material.dart';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alphabet"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 109, 107, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Image.asset(
            'assets/alphabet.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}