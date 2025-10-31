// import 'package:flutter/material.dart';
// import 'package:tailor_clothing_application/models/service_model.dart';
// import 'fabric_selection_screen.dart';

// class ServiceDetailScreen extends StatefulWidget {
//   final ServiceModel service;
//   const ServiceDetailScreen({super.key, required this.service});

//   @override
//   State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
// }

// class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
//   String? selectedFabricName;
//   double totalPrice = 0;

//   @override
//   void initState() {
//     super.initState();
//     totalPrice = widget.service.price;
//   }

//   void _openFabricSelection() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FabricSelectionScreen(
//           onFabricSelected: (fabric) {
//             setState(() {
//               selectedFabricName = fabric.name;
//               totalPrice = widget.service.price + fabric.price;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final service = widget.service;

//     return Scaffold(
//       appBar: AppBar(title: Text(service.name)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(service.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
//             const SizedBox(height: 20),
//             Text(
//               service.name,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               service.description,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Base Price: Rs ${service.price.toStringAsFixed(0)}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 20),
//             if (selectedFabricName != null)
//               Text(
//                 "Selected Fabric: $selectedFabricName",
//                 style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               ),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: _openFabricSelection,
//               icon: const Icon(Icons.checkroom),
//               label: const Text("Choose Fabric"),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Total Price:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Rs ${totalPrice.toStringAsFixed(0)}",
//                   style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Proceeding to order creation...')),
//                   );
//                   // In Module 4: Navigate to order creation screen
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 child: const Text(
//                   "Continue to Order",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tailor_clothing_application/models/service_model.dart';
import 'package:tailor_clothing_application/screens/catalog/fabric_selection_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? selectedFabricName;
  double totalPrice = 0;

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
              selectedFabricName = fabric.name;
              totalPrice = widget.service.price + fabric.price;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(service.imageUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(service.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(service.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 20),
            Text("Base Price: Rs ${service.price.toStringAsFixed(0)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            if (selectedFabricName != null)
              Text("Selected Fabric: $selectedFabricName",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
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
                const Text("Total Price:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Rs ${totalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Proceeding to order creation...')));
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
                child:
                    const Text("Continue to Order", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
