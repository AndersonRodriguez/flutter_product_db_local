import 'package:flutter/material.dart';
import 'package:flutter_product_db_local/bloc/product_bloc.dart';
import 'package:flutter_product_db_local/models/product.dart';
import 'package:flutter_product_db_local/providers/db_product_provider.dart';
import 'package:flutter_product_db_local/screens/add_product_screen.dart';
import 'package:flutter_product_db_local/screens/peroduct_details_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productBloc = ProductBloc();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de productos'),
        actions: [
          IconButton(
            onPressed: () {
              // DBProductProvider.db.deleteAll();
              productBloc.deleteAllProduct();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      // body: FutureBuilder(
      //   future: DBProductProvider.db.getAll(),
      body: StreamBuilder<List<Product>>(
        stream: productBloc.productStream,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data;

          if (products == null || products.isEmpty) {
            return const Center(
              child: Text('No tienes productos'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('${product.price}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(id: product.id!),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
