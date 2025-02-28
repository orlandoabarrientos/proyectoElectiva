import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sidebar.dart';
import 'navigationbar.dart';
import 'productocreate.dart';
import 'productoupdate.dart';

class getproducto extends StatefulWidget {
  const getproducto({super.key});

  @override
  State<getproducto> createState() => _getproductoState();
}

class _getproductoState extends State<getproducto> {
  List<Producto> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/product_read'));
      if (response.statusCode == 200) {
        List products = json.decode(response.body);
        setState(() {
          productos =
              products.map((product) => Producto.fromJson(product)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BarraNavegacion(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
      drawer: const MenuLateral(),
      appBar: AppBar(
        title: const Text('Listado de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductoPost()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: ProductSearchDelegate(productos));
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/iujologo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final product = productos[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mostrar la imagen del producto
                          Image.network(
                            product.imagen_url,
                            height: 300, // Ajusta el tamaño según necesites
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.nombre,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductoUpdate(
                                            codigo: product.codigo,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              ' Confirmar para eliminar'),
                                          content: const Text(
                                              '¿Seguro que quieres realizar esta acción?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmDelete) {
                                        final response = await http.delete(
                                          Uri.parse(
                                              'http://10.0.2.2:8000/product_delete'),
                                          body: json.encode(
                                              {'codigo': product.codigo}),
                                          headers: {
                                            'Content-Type': 'application/json'
                                          },
                                        );
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            productos.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Producto eliminado')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Error al eliminar el producto')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            product.descripcion,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Código: ${product.codigo}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Cantidad: ${product.cantidad}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Precio: \$${product.precio.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Impuesto: ${product.impuesto}%',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLoading = true; // Mostrar el indicador de carga
          });
          _fetchProducts(); // Recargar los productos
        },
        child: const Icon(Icons.refresh), // Ícono de recarga
        backgroundColor: Colors.blue, // Color del botón
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Producto> productos;

  ProductSearchDelegate(this.productos);

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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = productos
        .where((product) =>
            product.codigo.toLowerCase().contains(query.toLowerCase()) ||
            product.nombre.toLowerCase().contains(query.toLowerCase()) ||
            product.descripcion.toLowerCase().contains(query.toLowerCase()) ||
            product.cantidad.toString().contains(query) ||
            product.precio.toString().contains(query) ||
            product.impuesto.toString().contains(query))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nombre,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  product.descripcion,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Código: ${product.codigo}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Cantidad: ${product.cantidad}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Precio: \$${product.precio.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Impuesto: ${product.impuesto}%',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Muestra un contenedor vacío al inicio
  }
}

class Producto {
  final String codigo;
  final String nombre;
  final String descripcion;
  final int cantidad;
  final double precio;
  final double impuesto;
  final String imagen_url;

  Producto({
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    required this.impuesto,
    required this.imagen_url,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'],
      precio: json['precio'].toDouble(),
      impuesto: json['impuesto'].toDouble(),
      imagen_url: "http://10.0.2.2:8000${json['imagen_url']}",
    );
  }
}
