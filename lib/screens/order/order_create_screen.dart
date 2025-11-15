
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/app_theme.dart';

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
  String? _measurements;
  DateTime? _deliveryDate;
  double _totalAmount = 0.0;

  List<Map<String, dynamic>> _tailors = [];
  List<Map<String, dynamic>> _services = [];
  bool _loading = false;

  final supabase = Supabase.instance.client;
  final _heightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _shoulderController = TextEditingController();
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

  Future<void> _addNewTailor() async {
    final nameController = TextEditingController();
    final shopController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.person_add, color: AppTheme.primary, size: 24),
            const SizedBox(width: 8),
            const Text('Add New Tailor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tailor Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: shopController,
              decoration: const InputDecoration(
                labelText: 'Shop Name',
                prefixIcon: Icon(Icons.store),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              final insert = await supabase.from('tailors').insert({
                'display_name': nameController.text,
                'shop_name': shopController.text,
                'created_at': DateTime.now().toIso8601String(),
              }).select().single();

              setState(() {
                _tailors.add(insert);
                _selectedTailorId = insert['id'].toString();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewService() async {
    final titleController = TextEditingController();
    final priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.add_circle, color: AppTheme.accent, size: 24),
            const SizedBox(width: 8),
            const Text('Add New Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Service Name / Title',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price (Rs.)',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              try {
                final insertData = {
                  'price': double.tryParse(priceController.text) ?? 0,
                  'created_at': DateTime.now().toIso8601String(),
                };

                if (_services.isNotEmpty && _services.first.containsKey('title')) {
                  insertData['title'] = titleController.text;
                } else if (_services.isNotEmpty && _services.first.containsKey('name')) {
                  insertData['name'] = titleController.text;
                }

                if (_services.isNotEmpty && _services.first.containsKey('type')) {
                  insertData['type'] = _orderType;
                }

                final insert = await supabase.from('services').insert(insertData).select().single();

                setState(() {
                  _services.add(insert);
                  _selectedServiceId = insert['id'].toString();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add service failed: $e')));
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
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

    // ✅ Combine height, length, and shoulder
    _measurements =
        "Height: ${_heightController.text}, Length: ${_lengthController.text}, Shoulder: ${_shoulderController.text}";

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

  @override
  Widget build(BuildContext context) {
    final dateText = _deliveryDate == null
        ? 'Select delivery date'
        : DateFormat.yMMMd().format(_deliveryDate!);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Create Order',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Type Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.category, color: AppTheme.primary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Order Type',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildRadioOption('stitching', 'Stitching', Icons.content_cut),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildRadioOption('rental', 'Rental', Icons.checkroom),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Service Selection Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shopping_bag, color: AppTheme.accent, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Choose Service',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedServiceId,
                              decoration: InputDecoration(
                                labelText: 'Select Service',
                                prefixIcon: const Icon(Icons.label),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add_circle, color: AppTheme.accent),
                                  onPressed: _addNewService,
                                  tooltip: 'Add New Service',
                                ),
                              ),
                              items: _services
                                  .map((s) => DropdownMenuItem(
                                        value: s['id'].toString(),
                                        child: Text(s['title']?.toString() ?? s['name']?.toString() ?? 'Unnamed Service'),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedServiceId = v),
                              validator: (v) => v == null ? 'Please select service' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tailor Selection Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: AppTheme.primary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Assign Tailor',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Optional',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedTailorId,
                              decoration: InputDecoration(
                                labelText: 'Select Tailor',
                                prefixIcon: const Icon(Icons.person_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add_circle, color: AppTheme.primary),
                                  onPressed: _addNewTailor,
                                  tooltip: 'Add New Tailor',
                                ),
                              ),
                              items: _tailors
                                  .map((t) => DropdownMenuItem(
                                        value: t['id'].toString(),
                                        child: Text(t['display_name']?.toString() ?? 'Unnamed Tailor'),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedTailorId = v),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Measurements Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.straighten, color: AppTheme.accent, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Measurements',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Height (in inches/cm)',
                                prefixIcon: Icon(Icons.height),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _lengthController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Length (in inches/cm)',
                                prefixIcon: Icon(Icons.straighten),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _shoulderController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Shoulder (in inches/cm)',
                                prefixIcon: Icon(Icons.width_wide),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment & Delivery Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.payment, color: AppTheme.primary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Payment & Delivery',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Total Amount',
                                prefixIcon: Icon(Icons.attach_money),
                                prefixText: 'Rs. ',
                              ),
                              onChanged: (v) => setState(() => _totalAmount = double.tryParse(v) ?? 0.0),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppTheme.accent.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: AppTheme.accent, size: 20),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Delivery Date',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                dateText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: _deliveryDate == null ? Colors.grey[600] : Colors.grey[900],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: _pickDeliveryDate,
                                    icon: const Icon(Icons.event, size: 18),
                                    label: const Text('Pick'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle, size: 24),
                        label: const Text(
                          'Create Order',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRadioOption(String value, String label, IconData icon) {
    final isSelected = _orderType == value;
    return GestureDetector(
      onTap: () => setState(() => _orderType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _orderType,
              onChanged: (v) => setState(() => _orderType = v!),
              activeColor: AppTheme.primary,
            ),
            Icon(icon, size: 20, color: isSelected ? AppTheme.primary : Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
