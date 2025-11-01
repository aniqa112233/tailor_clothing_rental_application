// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/models/fabric_model.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/widgets/fabric_chip.dart';
// class FabricSelectionScreen extends StatefulWidget {
//   final void Function(FabricModel selectedFabric) onFabricSelected;

//   const FabricSelectionScreen({super.key, required this.onFabricSelected});

//   @override
//   State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
// }

// class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
//   FabricModel? _selectedFabric;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<CatalogProvider>(context, listen: false).fetchFabrics();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CatalogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Select Fabric")),
//       body: provider.fabrics.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: ListView(
//                 children: [
//                   Wrap(
//                     spacing: 8,
//                     children: provider.fabrics.map((fabric) {
//                       return FabricChip(
//                         fabric: fabric,
//                         selected: _selectedFabric?.id == fabric.id,
//                         onTap: () {
//                           setState(() => _selectedFabric = fabric);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 30),
//                   if (_selectedFabric != null)
//                     Card(
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             Image.network(_selectedFabric!.imageUrl, height: 150),
//                             const SizedBox(height: 10),
//                             Text(
//                               _selectedFabric!.name,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text("Type: ${_selectedFabric!.type}"),
//                             Text("Color: ${_selectedFabric!.color}"),
//                             Text("Price: Rs ${_selectedFabric!.price}"),
//                             Text("Available Stock: ${_selectedFabric!.stock}"),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 widget.onFabricSelected(_selectedFabric!);
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Select This Fabric"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/models/fabric_model.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/widgets/fabric_chip.dart';

// class FabricSelectionScreen extends StatefulWidget {
//   final void Function(FabricModel selectedFabric) onFabricSelected;

//   const FabricSelectionScreen({super.key, required this.onFabricSelected});

//   @override
//   State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
// }

// class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
//   FabricModel? _selectedFabric;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<CatalogProvider>(context, listen: false).fetchFabrics();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CatalogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Select Fabric")),
//       body: provider.fabrics.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: ListView(
//                 children: [
//                   Wrap(
//                     spacing: 8,
//                     children: provider.fabrics.map((fabric) {
//                       return FabricChip(
//                         fabric: fabric,
//                         selected: _selectedFabric?.id == fabric.id,
//                         onTap: () {
//                           setState(() => _selectedFabric = fabric);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 30),
//                   if (_selectedFabric != null)
//                     Card(
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             Image.network(_selectedFabric!.imageUrl,
//                                 height: 150),
//                             const SizedBox(height: 10),
//                             Text(_selectedFabric!.name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             Text("Type: ${_selectedFabric!.type}"),
//                             Text("Color: ${_selectedFabric!.color}"),
//                             Text("Price: Rs ${_selectedFabric!.price}"),
//                             Text(
//                                 "Available Stock: ${_selectedFabric!.stock.toString()}"),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 widget.onFabricSelected(_selectedFabric!);
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Select This Fabric"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/models/fabric_model.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/widgets/fabric_chip.dart';

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
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Fabric"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Fabric Name"),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: "Type"),
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: "Color"),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stock"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => pickedImage = File(picked.path));
                  }
                },
                icon: const Icon(Icons.photo_library),
                label: const Text("Pick Image"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
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
              await Provider.of<CatalogProvider>(context, listen: false).uploadFabric(
                bytes,
                nameController.text,
                typeController.text,
                colorController.text,
                double.parse(priceController.text),
                int.parse(stockController.text),
              );

              setState(() => _adding = false);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Fabric"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFabricDialog,
          ),
        ],
      ),
      body: _adding
          ? const Center(child: CircularProgressIndicator())
          : provider.fabrics.isEmpty
              ? const Center(child: Text("No fabrics yet. Tap + to add one."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Wrap(
                        spacing: 8,
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
                      const SizedBox(height: 30),
                      if (_selectedFabric != null)
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Image.network(_selectedFabric!.imageUrl, height: 150),
                                const SizedBox(height: 10),
                                Text(_selectedFabric!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                Text("Type: ${_selectedFabric!.type}"),
                                Text("Color: ${_selectedFabric!.color}"),
                                Text("Price: Rs ${_selectedFabric!.price}"),
                                Text("Available Stock: ${_selectedFabric!.stock}"),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.onFabricSelected(_selectedFabric!);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Select This Fabric"),
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
}
