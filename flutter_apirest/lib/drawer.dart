import 'package:flutter/material.dart';
import 'pantalla01.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage("assets/iujologo.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
            child: Text(
                '') //BoxDecoration //UserAccountDrawerHeader
            ), //DrawerHeader
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(' Bienvenido '),
          onTap: () {
            // Navigator.pop(context);
            //Navigator.pushNamed(context, './home');
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configuracion '),
          onTap: () {
            //Navigator.of(context).pop();
            //Navigator.pushNamed(context, './pantalla01');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Pantalla01()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Salir'),
          onTap: () {
            //Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ],
    ));
  }
}
