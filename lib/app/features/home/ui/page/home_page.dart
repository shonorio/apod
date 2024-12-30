import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    Modular.to.navigate('/apod');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo),
            label: 'Picture of the Day',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }

  void _onDestinationSelected(int index) {
    if (index == 0) {
      Modular.to.navigate('/apod');
    } else {
      Modular.to.navigate('/favorites');
    }

    setState(() {
      _selectedIndex = index;
    });
  }
}
