
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailor_clothing_application/models/service_model.dart';
import 'package:tailor_clothing_application/models/fabric_model.dart';
import 'package:tailor_clothing_application/screens/catalog/fabric_selection_screen.dart';
import 'package:tailor_clothing_application/screens/order/order_list_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? selectedFabricName;
  FabricModel? selectedFabric;
  double totalPrice = 0;
  bool _loading = false;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    totalPrice = widget.service.price;
  }

  void _openFabricSelection() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FabricSelectionScreen(
          onFabricSelected: (fabric) {
            setState(() {
              selectedFabric = fabric;
              selectedFabricName = fabric.name;
              totalPrice = widget.service.price + fabric.price;
            });
          },
        ),
      ),
    );
  }

  Future<void> _createOrder() async {
    if (selectedFabric == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a fabric before ordering.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception("User not logged in. Please log in again.");
      final userId = user.id;

      // ✅ Check if service exists in 'services' table, otherwise insert safely
      String serviceId = widget.service.id;
      final existing = await supabase.from('services').select('id').eq('id', serviceId);
      if (existing.isEmpty) {
        final inserted = await supabase.from('services').insert({
          'id': serviceId,
          'name': widget.service.name.isNotEmpty ? widget.service.name : 'Custom Design',
          'description': widget.service.description.isNotEmpty
              ? widget.service.description
              : 'Custom user design',
          'image_url': widget.service.imageUrl,
          'price': widget.service.price,
          // ✅ force valid category to pass CHECK constraint
          'category': 'custom',
        }).select('id').single();
        serviceId = inserted['id'].toString();
      }

      // ✅ Now safely insert order
      await supabase.from('orders').insert({
        'user_id': userId,
        'order_type': 'stitching',
        'service_id': serviceId,
        'status': 'Pending',
        'delivery_date': DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String(),
        'total_amount': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'measurements': {
          'fabric_name': selectedFabric!.name,
          'fabric_type': selectedFabric!.type,
          'fabric_color': selectedFabric!.color,
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderListScreen(userId: userId)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create order: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    service.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    service.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Base Price: Rs ${service.price.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  if (selectedFabricName != null)
                    Text(
                      "Selected Fabric: $selectedFabricName",
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _openFabricSelection,
                    icon: const Icon(Icons.checkroom),
                    label: const Text("Choose Fabric"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        "Rs ${totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _createOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text("Continue to Order", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
