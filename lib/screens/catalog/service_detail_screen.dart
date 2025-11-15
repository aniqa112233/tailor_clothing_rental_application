
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailor_clothing_application/models/service_model.dart';
import 'package:tailor_clothing_application/models/fabric_model.dart';
import 'package:tailor_clothing_application/screens/catalog/fabric_selection_screen.dart';
import 'package:tailor_clothing_application/screens/order/order_list_screen.dart';
import 'package:tailor_clothing_application/utils/app_theme.dart';

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
      appBar: AppBar(
        title: Text(
          service.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                strokeWidth: 2.5,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleek Image Container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        service.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: AppTheme.primary.withOpacity(0.1),
                            child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Service Info Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            service.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Base Price Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: AppTheme.accent, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Base Price",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Rs ${service.price.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Fabric Selection Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.checkroom, color: AppTheme.accent, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Fabric Selection",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (selectedFabricName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.accent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppTheme.accent, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      selectedFabricName!,
                                      style: TextStyle(
                                        color: AppTheme.accent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.grey, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    "No fabric selected",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _openFabricSelection,
                              icon: const Icon(Icons.checkroom, size: 16),
                              label: const Text("Choose Fabric", style: TextStyle(fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: AppTheme.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Total Price Card
                  Card(
                    elevation: 2,
                    color: AppTheme.primary.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart, color: AppTheme.primary, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Total Price",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Rs ${totalPrice.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Continue to Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Continue to Order",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }
}
