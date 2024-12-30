import 'package:flutter/material.dart';

class ApodPage extends StatelessWidget {
  const ApodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture of the Day'),
      ),
      body: const Center(
        child: Text('Picture of the Day'),
      ),
    );
  }
}
