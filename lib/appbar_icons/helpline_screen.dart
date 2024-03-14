import 'package:flutter/material.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline'),
      ),
      body: const Center(
        child: Text('Helpline Screen Content'),
      ),
    );
  }
}

