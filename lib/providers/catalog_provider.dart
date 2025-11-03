
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/fabric_model.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';

class CatalogProvider with ChangeNotifier {
  final CatalogService _service = CatalogService();

  bool loading = false;
  List<ServiceModel> services = [];
  List<ProductModel> rentalItems = [];
  List<FabricModel> fabrics = [];

  // ✅ Fetch both official & custom (pending + approved) designs
  Future<void> fetchServices(String category) async {
    loading = true;
    notifyListeners();
    services = await _service.fetchAllCatalogItems(category);
    loading = false;
    notifyListeners();
  }

  Future<void> fetchRentalItems() async {
    loading = true;
    notifyListeners();
    rentalItems = await _service.fetchRentalItems();
    loading = false;
    notifyListeners();
  }

  Future<void> fetchFabrics() async {
    fabrics = await _service.fetchFabrics();
    notifyListeners();
  }

  Future<void> uploadCustomDesign(
      Uint8List imageBytes, String notes, String userId) async {
    final fileName = 'design_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl = await _service.uploadDesignImage(imageBytes, fileName);
    await _service.saveCustomDesign(imageUrl, notes, userId);
  }

  Future<void> uploadFabric(
    Uint8List imageBytes,
    String name,
    String type,
    String color,
    double price,
    int stock,
  ) async {
    final fileName = 'fabric_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl = await _service.uploadFabricImage(imageBytes, fileName);
    await _service.saveFabric(imageUrl, name, type, color, price, stock);
    await fetchFabrics();
  }
}
