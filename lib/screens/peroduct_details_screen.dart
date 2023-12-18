import 'package:flutter/material.dart';
import 'package:flutter_product_db_local/bloc/product_bloc.dart';
import 'package:flutter_product_db_local/models/product.dart';
import 'package:flutter_product_db_local/providers/db_product_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();

  final productBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  _loadProductData() async {
    Product? product = await DBProductProvider.db.getById(widget.id);

    if (product != null) {
      _name.text = product.name;
      _price.text = product.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nombre del producto:'),
            TextField(
              controller: _name,
            ),
            const SizedBox(height: 20.0),
            const Text('Precio del producto:'),
            TextField(
              controller: _price,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // DBProductProvider.db.delete(widget.id);
                    productBloc.deleteProduct(widget.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Product product = Product(
                      id: widget.id,
                      name: _name.text,
                      price: double.parse(_price.text),
                    );
                    // DBProductProvider.db.update(widget.id, product);
                    productBloc.updateProduct(widget.id, product);
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
