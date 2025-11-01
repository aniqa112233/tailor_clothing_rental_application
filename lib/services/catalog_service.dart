// import 'dart:typed_data';

// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/service_model.dart';
// import '../models/fabric_model.dart';
// import '../models/product_model.dart';

// class CatalogService {
//   final supabase = Supabase.instance.client;

//   // 🔹 Fetch stitching services (men/women/kids)
//   Future<List<ServiceModel>> fetchServices(String category) async {
//     final response = await supabase.from('services').select().eq('category', category);
//     return (response as List)
//         .map((item) => ServiceModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Fetch rental items
//   Future<List<ProductModel>> fetchRentalItems() async {
//     final response = await supabase.from('rental_items').select();
//     return (response as List)
//         .map((item) => ProductModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Fetch available fabrics
//   Future<List<FabricModel>> fetchFabrics() async {
//     final response = await supabase.from('fabrics').select();
//     return (response as List)
//         .map((item) => FabricModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Upload custom design image to Supabase Storage
//   Future<String> uploadDesignImage(Uint8List imageBytes, String fileName) async {
//     await supabase.storage.from('designs').uploadBinary(fileName, imageBytes);
//     final publicUrl = supabase.storage.from('designs').getPublicUrl(fileName);
//     return publicUrl;
//   }

//   // 🔹 Save uploaded custom design info in database
//   Future<void> saveCustomDesign(String imageUrl, String notes, String userId) async {
//     await supabase.from('custom_designs').insert({
//       'user_id': userId,
//       'image_url': imageUrl,
//       'notes': notes,
//       'status': 'pending',
//     });
//   }

//   // 🔹 Fetch design templates (optional)
//   Future<List<Map<String, dynamic>>> fetchDesignTemplates() async {
//     final response = await supabase.from('design_templates').select();
//     return (response as List).map((e) => e as Map<String, dynamic>).toList();
//   }
// }

// import 'dart:typed_data';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/service_model.dart';
// import '../models/fabric_model.dart';
// import '../models/product_model.dart';

// class CatalogService {
//   final supabase = Supabase.instance.client;

//   // 🔹 Fetch stitching services (men/women/kids)
//   Future<List<ServiceModel>> fetchServices(String category) async {
//     final response =
//         await supabase.from('services').select().eq('category', category);
//     return (response as List)
//         .map((item) => ServiceModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Fetch rental items
//   Future<List<ProductModel>> fetchRentalItems() async {
//     final response = await supabase.from('rental_items').select();
//     return (response as List)
//         .map((item) => ProductModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Fetch available fabrics
//   Future<List<FabricModel>> fetchFabrics() async {
//     final response = await supabase.from('fabrics').select();
//     return (response as List)
//         .map((item) => FabricModel.fromJson(item))
//         .toList();
//   }

//   // 🔹 Upload custom design image to Supabase Storage
//   Future<String> uploadDesignImage(Uint8List imageBytes, String fileName) async {
//     await supabase.storage.from('designs').uploadBinary(fileName, imageBytes);
//     final publicUrl = supabase.storage.from('designs').getPublicUrl(fileName);
//     return publicUrl;
//   }

//   // 🔹 Save uploaded custom design info in database
//   Future<void> saveCustomDesign(
//       String imageUrl, String notes, String userId) async {
//     await supabase.from('custom_designs').insert({
//       'user_id': userId,
//       'image_url': imageUrl,
//       'notes': notes,
//       'status': 'pending',
//     });
//   }

//   // 🔹 Fetch design templates (optional)
//   Future<List<Map<String, dynamic>>> fetchDesignTemplates() async {
//     final response = await supabase.from('design_templates').select();
//     return (response as List).map((e) => e as Map<String, dynamic>).toList();
//   }

//   // ✅ NEW: Fetch all catalog items (services + custom designs)
//   Future<List<ServiceModel>> fetchAllCatalogItems(String category) async {
//     // 1️⃣ Get official services by category
//     final serviceList = await fetchServices(category);

//     // 2️⃣ Get custom designs (both pending & approved for now)
//     final customResponse = await supabase.from('custom_designs').select();

//     // 3️⃣ Map custom designs into ServiceModel-like objects
//     final designServices = (customResponse as List).map<ServiceModel>((d) {
//       return ServiceModel(
//         id: d['id'].toString(),
//         name: 'Custom Design',
//         description: d['notes'] ?? '',
//         imageUrl: d['image_url'] ?? '',
//         price: 0,
//         category: 'custom',
//       );
//     }).toList();

//     // 4️⃣ Combine and return
//     return [...serviceList, ...designServices];
//   }
// }
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';
import '../models/fabric_model.dart';
import '../models/product_model.dart';

class CatalogService {
  final supabase = Supabase.instance.client;

  Future<List<ServiceModel>> fetchServices(String category) async {
    final response =
        await supabase.from('services').select().eq('category', category);
    return (response as List)
        .map((item) => ServiceModel.fromJson(item))
        .toList();
  }

  Future<List<ProductModel>> fetchRentalItems() async {
    final response = await supabase.from('rental_items').select();
    return (response as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();
  }

  Future<List<FabricModel>> fetchFabrics() async {
    final response = await supabase.from('fabrics').select();
    return (response as List)
        .map((item) => FabricModel.fromJson(item))
        .toList();
  }

  Future<String> uploadDesignImage(Uint8List imageBytes, String fileName) async {
    await supabase.storage.from('designs').uploadBinary(fileName, imageBytes);
    return supabase.storage.from('designs').getPublicUrl(fileName);
  }

  Future<void> saveCustomDesign(String imageUrl, String notes, String userId) async {
    await supabase.from('custom_designs').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'notes': notes,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> fetchDesignTemplates() async {
    final response = await supabase.from('design_templates').select();
    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<ServiceModel>> fetchAllCatalogItems(String category) async {
    final serviceList = await fetchServices(category);
    final customResponse = await supabase.from('custom_designs').select().eq('status', 'approved');
    final designServices = (customResponse as List).map<ServiceModel>((d) {
      return ServiceModel(
        id: d['id'].toString(),
        name: 'Custom Design',
        description: d['notes'] ?? '',
        imageUrl: d['image_url'] ?? '',
        price: 0,
        category: 'custom',
      );
    }).toList();
    return [...serviceList, ...designServices];
  }

  // ✅ NEW: upload fabric image & save fabric record
  Future<String> uploadFabricImage(Uint8List imageBytes, String fileName) async {
    await supabase.storage.from('fabrics').uploadBinary(fileName, imageBytes);
    return supabase.storage.from('fabrics').getPublicUrl(fileName);
  }

  Future<void> saveFabric(String imageUrl, String name, String type, String color,
      double price, int stock) async {
    await supabase.from('fabrics').insert({
      'name': name,
      'type': type,
      'color': color,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    });
  }
}
