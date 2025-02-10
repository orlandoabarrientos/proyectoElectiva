import 'package:flutter/material.dart';
import 'package:flutter_apirest/home.dart';
import 'getproducto.dart';

class BarraNavegacion extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BarraNavegacion({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Salir',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            if (ModalRoute.of(context)?.settings.name != '/') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
            break;
          case 1:
            if (ModalRoute.of(context)?.settings.name != 'getproducto') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const getproducto()),
              );
            }
            break;
          case 2:
            if (Navigator.canPop(context)) {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name !=
                      ModalRoute.of(context)?.settings.name);
            }
            break;
        }
        onItemTapped(index);
      },
    );
  }
}
