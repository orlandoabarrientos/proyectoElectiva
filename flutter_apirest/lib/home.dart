// usar < flutter pub get > para cargar los paquetes
import 'package:flutter/material.dart';
import 'getproducto.dart';
import 'sidebar.dart';
import 'navigationbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Electiva I',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 0, 193, 241)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Formulario de Captura de datos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _HomeState();
}

class _HomeState extends State<MyHomePage> {
  //variables

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Formatea la fecha y hora
    return Scaffold(
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
      drawer: const MenuLateral(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Navegacion entre Pantallas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Bienvenidos al cosultar de productos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(now.toString()),
                const Text('Integrantes : Osman Cordero, '
                    'Orlando Barrientos, '
                    'Jhon Blanco, '
                    'Fabiola Cordero, '
                    'Maria Gutierrz, '
                    'Emanuel Rivero, '
                    'Edith Escalona,'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const getproducto()));
                    },
                    child: const Text('Entrar')),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ],
      ),
    );
  }
}
