import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final String model;
  final String macAddress;
  bool status;
  int? temperature;

  Product({
    required this.id,
    required this.name,
    required this.model,
    required this.macAddress,
    required this.status,
    this.temperature,
  });
}

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];

  User? _user;

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('smartDevices')
          .get();
      _products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: data['id'] as int,
          name: data['name'] as String,
          model: data['model'] as String,
          macAddress: data['macAddress'] as String,
          status: data['status'] as bool,
          temperature: data['temperature'] as int,
        );
      }).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> updateProductStatus(int productId, bool newStatus) async {
    try {
      final DocumentReference productRef =
          _firestore.collection('products').doc(productId.toString());

      await productRef.update({'status': newStatus});
      fetchProducts();
      notifyListeners();
    } catch (error) {
      print('Error updating product status: $error');
    }
  }

  Future<void> updateProductTemperature(
      int productId, int newTemperature) async {
    try {
      final DocumentReference productRef =
          _firestore.collection('products').doc(productId.toString());

      await productRef.update({'temperature': newTemperature});
      fetchProducts();
      notifyListeners();
    } catch (error) {
      print('Error updating product temperature: $error');
    }
  }
}
