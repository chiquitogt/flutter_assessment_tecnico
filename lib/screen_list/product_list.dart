import '../models/product.dart';
import '../services/services_mock_api.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ServicesMockApi _servicesMockApi = ServicesMockApi();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _servicesMockApi.fetchProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Productos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar productos',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterProducts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
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
