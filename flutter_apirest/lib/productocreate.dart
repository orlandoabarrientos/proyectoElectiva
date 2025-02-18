import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductoPost extends StatefulWidget {
  @override
  _ProductoPostState createState() => _ProductoPostState();
}

class _ProductoPostState extends State<ProductoPost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _impuestoController = TextEditingController();
  File? _image;
  String? _base64Image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        _image = imageFile;
        _base64Image = base64Image;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> productData = {
        'codigo': _codigoController.text,
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'cantidad': int.parse(_cantidadController.text),
        'precio': double.parse(_precioController.text),
        'impuesto': double.parse(_impuestoController.text),
        'imagen_base64': _base64Image, // Enviar la imagen en Base64
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/product_create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Producto agregado con éxito'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          ),
        );
        await Future.delayed(Duration(seconds: 2)); // Espera 2 segundos
        Navigator.pop(context); // Vuelve a la ventana anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar el producto'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_codigoController, 'Código'),
              _buildTextField(_nombreController, 'Nombre'),
              _buildTextField(_descripcionController, 'Descripción'),
              _buildTextField(_cantidadController, 'Cantidad', isNumber: true),
              _buildTextField(_precioController, 'Precio', isNumber: true),
              _buildTextField(_impuestoController, 'Impuesto', isNumber: true),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _pickImage, child: Text('Seleccionar Imagen')),
              SizedBox(height: 20),
              _image == null
                  ? Text('No se ha seleccionado ninguna imagen.')
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitForm, child: Text('Agregar Producto')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }
}
