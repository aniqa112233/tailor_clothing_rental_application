
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderCreateScreen extends StatefulWidget {
  final String userId;
  const OrderCreateScreen({super.key, required this.userId});

  @override
  State<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends State<OrderCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _orderType = 'stitching';
  String? _selectedTailorId;
  String? _selectedServiceId;
  Map<String, dynamic>? _measurements;
  DateTime? _deliveryDate;
  double _totalAmount = 0.0;

  List<Map<String, dynamic>> _tailors = [];
  List<Map<String, dynamic>> _services = [];
  bool _loading = false;

  final supabase = Supabase.instance.client;
  final _measurementController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTailorsAndServices();
  }

  Future<void> _fetchTailorsAndServices() async {
    try {
      setState(() => _loading = true);
      final tailorsData = await supabase.from('tailors').select('*');
      final servicesData = await supabase.from('services').select('*');
      _tailors = (tailorsData as List).map((e) => e as Map<String, dynamic>).toList();
      _services = (servicesData as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fetch error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  // 🆕 Add Tailor
  Future<void> _addNewTailor() async {
    final nameController = TextEditingController();
    final shopController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tailor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tailor Name')),
            TextField(controller: shopController, decoration: const InputDecoration(labelText: 'Shop Name')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              final insert = await supabase.from('tailors').insert({
                'display_name': nameController.text,
                'shop_name': shopController.text,
                'created_at': DateTime.now().toIso8601String(),
              }).select().single();

              setState(() {
                _tailors.add(insert as Map<String, dynamic>);
                _selectedTailorId = insert['id'].toString();
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // 🆕 Add Service (safe for missing 'type' / 'title')
  Future<void> _addNewService() async {
    final titleController = TextEditingController();
    final priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Service Name / Title')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price (Rs.)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              try {
                // ✅ prepare data without forcing 'type' column
                final insertData = {
                  'price': double.tryParse(priceController.text) ?? 0,
                  'created_at': DateTime.now().toIso8601String(),
                };

                // optional columns (only if they exist in table)
                if (_services.isNotEmpty && _services.first.containsKey('title')) {
                  insertData['title'] = titleController.text;
                } else if (_services.isNotEmpty && _services.first.containsKey('name')) {
                  insertData['name'] = titleController.text;
                }

                // add order_type only if your table has 'type' column
                if (_services.isNotEmpty && _services.first.containsKey('type')) {
                  insertData['type'] = _orderType;
                }

                final insert = await supabase.from('services').insert(insertData).select().single();

                setState(() {
                  _services.add(insert as Map<String, dynamic>);
                  _selectedServiceId = insert['id'].toString();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add service failed: $e')));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDeliveryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _deliveryDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a service')));
      return;
    }

    setState(() => _loading = true);

    final selectedService = _services.firstWhere(
      (s) => s['id'].toString() == _selectedServiceId,
      orElse: () => {},
    );
    final selectedTailor = _tailors.firstWhere(
      (t) => t['id'].toString() == _selectedTailorId,
      orElse: () => {},
    );

    final order = {
      'user_id': widget.userId,
      'tailor_id': _selectedTailorId,
      'order_type': _orderType,
      'service_id': _selectedServiceId,
      'measurements': _measurements,
      'status': 'Pending',
      'delivery_date': _deliveryDate?.toIso8601String(),
      'total_amount': _totalAmount,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'tailor_name': selectedTailor['display_name'] ?? '',
      'shop_name': selectedTailor['shop_name'] ?? '',
      'service_title': selectedService['title'] ?? selectedService['name'] ?? '',
      'service_price': selectedService['price'] ?? 0,
    };

    try {
      await supabase.from('orders').insert(order);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order created successfully!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create order failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onMeasurementsChanged(String text) {
    try {
      final parsed = jsonDecode(text);
      if (parsed is Map<String, dynamic>) _measurements = parsed;
    } catch (_) {
      _measurements = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _deliveryDate == null
        ? 'Select delivery date'
        : DateFormat.yMMMd().format(_deliveryDate!);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Stitching'),
                            leading: Radio<String>(
                              value: 'stitching',
                              groupValue: _orderType,
                              onChanged: (v) => setState(() => _orderType = v!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Rental'),
                            leading: Radio<String>(
                              value: 'rental',
                              groupValue: _orderType,
                              onChanged: (v) => setState(() => _orderType = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // === Choose Service ===
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedServiceId,
                            decoration: const InputDecoration(labelText: 'Choose Service'),
                            items: _services
                                .map((s) => DropdownMenuItem(
                                      value: s['id'].toString(),
                                      child: Text(s['title']?.toString() ?? s['name']?.toString() ?? 'Unnamed Service'),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedServiceId = v),
                            validator: (v) => v == null ? 'Please select service' : null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
                          onPressed: _addNewService,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // === Assign Tailor ===
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedTailorId,
                            decoration: const InputDecoration(labelText: 'Assign Tailor (optional)'),
                            items: _tailors
                                .map((t) => DropdownMenuItem(
                                      value: t['id'].toString(),
                                      child: Text(t['display_name']?.toString() ?? 'Unnamed Tailor'),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedTailorId = v),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
                          onPressed: _addNewTailor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _measurementController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Measurements (JSON)',
                        helperText: '{"height": 36, "length": 28}',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _onMeasurementsChanged,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Total Amount', prefixText: 'Rs. '),
                      onChanged: (v) => setState(() => _totalAmount = double.tryParse(v) ?? 0.0),
                    ),
                    const SizedBox(height: 12),

                    ListTile(
                      title: Text('Delivery date: $dateText'),
                      trailing: ElevatedButton(onPressed: _pickDeliveryDate, child: const Text('Pick')),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Create Order'),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
