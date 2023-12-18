import 'package:flutter/material.dart';
import 'package:flutter_product_db_local/bloc/product_bloc.dart';
import 'package:flutter_product_db_local/models/product.dart';
import 'package:flutter_product_db_local/providers/db_product_provider.dart';

class AddProductScreen extends StatelessWidget {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();

  final productBloc = ProductBloc();

  AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Product product = Product(
                  name: _name.text,
                  price: double.parse(_price.text),
                );
                // DBProductProvider.db.add(product);
                productBloc.addProduct(product);

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
