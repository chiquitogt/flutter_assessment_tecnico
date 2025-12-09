import '../models/product.dart';
import '../services/services_mock_api.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key}); // Constructor del widget ProductList

  @override
  State<ProductList> createState() => _ProductListState(); // Crear el estado del widget ProductList
}

class _ProductListState extends State<ProductList> {
  final ServicesMockApi _servicesMockApi =
      ServicesMockApi(); // Instancia del servicio de API simulado
  List<Product> _products = []; // Lista de productos cargados
  List<Product> _filteredProducts = []; // Lista de productos filtrados

  @override
  void initState() {
    super.initState(); // Inicializar el estado
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Se Carga productos desde la API simulada
    final products = await _servicesMockApi
        .fetchProducts(); // Obtener productos
    setState(() {
      // Actualizar el estado con los productos obtenidos
      _products = products;
      _filteredProducts =
          products; // Inicialmente los productos están en la lista filtrada
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts =
          _products // Filtrar productos por nombre
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construir la interfaz de usuario
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Productos')),
      body: Column(
        children: [
          // Columna que contiene el campo de texto y la lista de productos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Campo de texto para filtrar productos
              decoration: InputDecoration(
                labelText: 'Filtrar productos',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  _filterProducts, // Llamar a la función de filtrado al cambiar el texto
            ),
          ),
          Expanded(
            child: ListView.builder(
              // Lista de productos filtrados
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  // Mostrar cada producto en un ListTile
                  title: Text(product.name),
                  subtitle: Text('Precio: \$${product.price}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
