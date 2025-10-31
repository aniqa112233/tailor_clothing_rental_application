// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/service_model.dart';
// import '../models/fabric_model.dart';
// import '../models/product_model.dart';

// class CatalogProvider with ChangeNotifier {
//   final supabase = Supabase.instance.client;

//   bool loading = false;
//   List<ServiceModel> services = [];
//   List<ProductModel> rentalItems = [];
//   List<FabricModel> fabrics = [];

//   Future<void> fetchServices(String category) async {
//     loading = true;
//     notifyListeners();
//     final response =
//         await supabase.from('services').select().eq('category', category);
//     services = (response as List)
//         .map((data) => ServiceModel.fromJson(data))
//         .toList();
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchRentalItems() async {
//     loading = true;
//     notifyListeners();
//     final response = await supabase.from('rental_items').select();
//     rentalItems =
//         (response as List).map((e) => ProductModel.fromJson(e)).toList();
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchFabrics() async {
//     final response = await supabase.from('fabrics').select();
//     fabrics = (response as List).map((e) => FabricModel.fromJson(e)).toList();
//     notifyListeners();
//   }

//   Future<void> uploadCustomDesign(String imageUrl, String notes) async {
//     await supabase.from('custom_designs').insert({
//       'user_id': supabase.auth.currentUser!.id,
//       'image_url': imageUrl,
//       'notes': notes,
//     });
//   }
// }
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import '../models/service_model.dart';
// import '../models/fabric_model.dart';
// import '../models/product_model.dart';
// import '../services/catalog_service.dart';

// class CatalogProvider with ChangeNotifier {
//   final CatalogService _service = CatalogService();

//   bool loading = false;
//   List<ServiceModel> services = [];
//   List<ProductModel> rentalItems = [];
//   List<FabricModel> fabrics = [];

//   Future<void> fetchServices(String category) async {
//     loading = true;
//     notifyListeners();
//     services = await _service.fetchServices(category);
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchRentalItems() async {
//     loading = true;
//     notifyListeners();
//     rentalItems = await _service.fetchRentalItems();
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchFabrics() async {
//     fabrics = await _service.fetchFabrics();
//     notifyListeners();
//   }

//   Future<void> uploadCustomDesign(Uint8List imageBytes, String notes, String userId) async {
//     final fileName = 'design_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final imageUrl = await _service.uploadDesignImage(imageBytes, fileName);
//     await _service.saveCustomDesign(imageUrl, notes, userId);
//   }
// }saiii thaaaa
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

  // ✅ Updated to include both official + custom designs
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
}
