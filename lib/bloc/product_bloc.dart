import 'dart:async';

import 'package:flutter_product_db_local/models/product.dart';
import 'package:flutter_product_db_local/providers/db_product_provider.dart';

class ProductBloc {
  static final ProductBloc _sigleton = ProductBloc._internal();

  final _productsController = StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get productStream => _productsController.stream;

  factory ProductBloc() => _sigleton;

  ProductBloc._internal() {
    getProducts();
  }

  disponse() {
    _productsController.close();
  }

  getProducts() async {
    _productsController.sink.add(await DBProductProvider.db.getAll());
  }

  addProduct(Product product) async {
    await DBProductProvider.db.add(product);
    getProducts();
  }

  updateProduct(int id, Product product) async {
    await DBProductProvider.db.update(id, product);
    getProducts();
  }

  deleteProduct(int id) async {
    await DBProductProvider.db.delete(id);
    getProducts();
  }

  deleteAllProduct() async {
    await DBProductProvider.db.deleteAll();
    getProducts();
  }
}
