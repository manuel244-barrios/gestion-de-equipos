import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'equipos/equipos_list_screen.dart';
import 'verificar/verificar_equipos_screen.dart';
import 'notificaciones/notificaciones_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const EquiposListScreen(),
    const VerificarEquiposScreen(),
    const NotificacionesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF673AB7),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Equipos'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Verificar'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
      ),
    );
  }
}
