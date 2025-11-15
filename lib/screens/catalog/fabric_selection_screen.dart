
import 'dart:io';
// ignore: unused_import
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/models/fabric_model.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/widgets/fabric_chip.dart';
import 'package:tailor_clothing_application/utils/app_theme.dart';

class FabricSelectionScreen extends StatefulWidget {
  final void Function(FabricModel selectedFabric) onFabricSelected;

  const FabricSelectionScreen({super.key, required this.onFabricSelected});

  @override
  State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
}

class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
  FabricModel? _selectedFabric;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogProvider>(context, listen: false).fetchFabrics();
  }

  Future<void> _showAddFabricDialog() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final colorController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    File? pickedImage;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.add_circle, color: AppTheme.primary, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Add New Fabric",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sleek Image Picker Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt, color: AppTheme.accent),
                                      title: const Text('Take a Photo'),
                                      onTap: () async {
                                        final picked = await picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 70,
                                          maxWidth: 1024,
                                        );
                                        if (picked != null) {
                                          setDialogState(
                                              () => pickedImage = File(picked.path));
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library, color: AppTheme.accent),
                                      title: const Text('Choose from Gallery'),
                                      onTap: () async {
                                        final picked = await picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 70,
                                          maxWidth: 1024,
                                        );
                                        if (picked != null) {
                                          setDialogState(
                                              () => pickedImage = File(picked.path));
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text("Pick Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Image Preview
                  if (pickedImage != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          pickedImage!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Fabric Info Fields
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Fabric Name",
                      prefixIcon: Icon(Icons.label),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      labelText: "Type",
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: colorController,
                    decoration: const InputDecoration(
                      labelText: "Color",
                      prefixIcon: Icon(Icons.palette),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock",
                      prefixIcon: Icon(Icons.inventory),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      typeController.text.isEmpty ||
                      colorController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      stockController.text.isEmpty ||
                      pickedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All fields are required!")),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  setState(() => _adding = true);

                  final bytes = await pickedImage!.readAsBytes();
                  await Provider.of<CatalogProvider>(context, listen: false)
                      .uploadFabric(
                    bytes,
                    nameController.text,
                    typeController.text,
                    colorController.text,
                    double.parse(priceController.text),
                    int.parse(stockController.text),
                  );

                  setState(() => _adding = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fabric added successfully!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Fabric",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddFabricDialog,
            tooltip: "Add New Fabric",
          ),
        ],
      ),
      body: _adding
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                strokeWidth: 2.5,
              ),
            )
          : provider.fabrics.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checkroom,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No fabrics yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap + to add one",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _showAddFabricDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Fabric"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView(
                    children: [
                      // Fabric Chips Section
                      Text(
                        "Available Fabrics",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.fabrics.map((fabric) {
                          return FabricChip(
                            fabric: fabric,
                            selected: _selectedFabric?.id == fabric.id,
                            onTap: () {
                              setState(() => _selectedFabric = fabric);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      
                      // Selected Fabric Details Card
                      if (_selectedFabric != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Fabric Image
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      _selectedFabric!.imageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 180,
                                          color: AppTheme.primary.withOpacity(0.1),
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Fabric Name
                                Text(
                                  _selectedFabric!.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Fabric Details
                                _buildDetailRow(
                                  Icons.category,
                                  "Type",
                                  _selectedFabric!.type,
                                  AppTheme.accent,
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.palette,
                                  "Color",
                                  _selectedFabric!.color,
                                  AppTheme.accent,
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.attach_money,
                                  "Price",
                                  "Rs ${_selectedFabric!.price.toStringAsFixed(0)}",
                                  AppTheme.primary,
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.inventory,
                                  "Available Stock",
                                  "${_selectedFabric!.stock}",
                                  AppTheme.accent,
                                ),
                                const SizedBox(height: 16),
                                
                                // Select Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.onFabricSelected(_selectedFabric!);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text("Select This Fabric"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }
}
