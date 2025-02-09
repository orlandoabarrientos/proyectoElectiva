import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'drawer.dart';

class Pantalla01 extends StatefulWidget {
  const Pantalla01({super.key});

  @override
  State<Pantalla01> createState() => _Pantalla01State();
}

class _Pantalla01State extends State<Pantalla01> {
  @override
  void initState() {
    super.initState();
  
    // Valor inicial
  }

  final TextEditingController controllerIP = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      appBar: AppBar(
        title: const Text('Configuracion de API'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/iujologo.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: <Widget>[
            // Otros widgets que desees agregar
          ],
        ),
      ),
    );
  }
}

//AQUI EMPIEZA LA PANTALLA DEL BUSCAAR
class ProductSearchDelegate extends SearchDelegate {
  //aqui se empiza a listar los productos con la clase que se creo al final
  Future<List<Producto>> _fetchProducts(String query) async {
    //esta funcion es la que se encarga de buscar la api 
    //si la ip 127.0.0.1 no la consigue pon 10.0.2.2 ya que esta es la que detecta flutter como localhost en ocasiones
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/productos_get'));
    //se le asiga el nombre response para no estar escribiendo a cada rato el uri
    if (response.statusCode == 200) {
      //lista dinamica donde se convirtieron los textos en objetos
      List products = json.decode(response.body);
      return products
          .map((product) => Producto.fromJson(product))
          .where((product) =>
              product.codigo.toLowerCase().contains(query.toLowerCase())) // Cambio aquí para buscar por código
          .toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: _fetchProducts(query),
      //AsyncSnapshot contiene el estado y los datos de la interacción más reciente con el Future que se está construyendo (en este caso, _fetchProducts(query)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay resultados'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                title: Text(product.descripcion),
                subtitle: Text('Codigo: ${product.codigo}, Nombre: ${product.nombre},Cantidad: ${product.cantidad}, Precio: ${product.precio}, Impuesto: ${product.impuesto}'),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

//Clase para poder llamarla mas en la listview 
class Producto {
  final String codigo;
  final String nombre;
  final String descripcion;
  final int cantidad;
  final double precio;
  final double impuesto;

  Producto({required this.codigo, required this.nombre,required this.descripcion, required this.cantidad, required this.precio, required this.impuesto});

//esto es como se muestra en la base de datos y en el json y se hjace para hacer la lista dinamica
//factory es para mapear los datos y recibe los json
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      impuesto: json['impuesto'],
    );
  }
}
