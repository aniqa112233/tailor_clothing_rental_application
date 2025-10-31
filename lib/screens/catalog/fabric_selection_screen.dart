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
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<CatalogProvider>(context, listen: false).fetchFabrics();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Fabric")),
      body: provider.fabrics.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
                            Image.network(_selectedFabric!.imageUrl,
                                height: 150),
                            const SizedBox(height: 10),
                            Text(_selectedFabric!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Type: ${_selectedFabric!.type}"),
                            Text("Color: ${_selectedFabric!.color}"),
                            Text("Price: Rs ${_selectedFabric!.price}"),
                            Text(
                                "Available Stock: ${_selectedFabric!.stock.toString()}"),
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
