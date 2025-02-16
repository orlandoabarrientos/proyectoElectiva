import 'package:flutter/material.dart';
import 'package:flutter_apirest/home.dart';
import 'productolist.dart';

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
            child: Text('') 
            ), 
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(' Bienvenido '),
          onTap: () {
           
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Listado de Productos'),
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != 'getproducto') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const getproducto()),
              );
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Salir'),
          onTap: () {
            //Navigator.pop(context);

            if (Navigator.canPop(context)) {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name !=
                      ModalRoute.of(context)?.settings.name);
            }
          },
        ),
      ],
    ));
  }
}
