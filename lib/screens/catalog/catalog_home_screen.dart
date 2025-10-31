// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/widgets/service_card.dart';
// class CatalogHomeScreen extends StatefulWidget {
//   const CatalogHomeScreen({super.key});

//   @override
//   State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
// }

// class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
//   String category = 'men';

//   @override
//   void initState() {
//     super.initState();
//     final provider = Provider.of<CatalogProvider>(context, listen: false);
//     provider.fetchServices(category);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CatalogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product & Service Catalog"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (val) {
//               setState(() => category = val);
//               provider.fetchServices(val);
//             },
//             itemBuilder: (_) => [
//               const PopupMenuItem(value: 'men', child: Text("Men")),
//               const PopupMenuItem(value: 'women', child: Text("Women")),
//               const PopupMenuItem(value: 'kids', child: Text("Kids")),
//             ],
//           )
//         ],
//       ),
//       body: provider.loading
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: provider.services.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.8,
//               ),
//               itemBuilder: (context, i) {
//                 return ServiceCard(service: provider.services[i]);
//               },
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/screens/catalog/service_detail_screen.dart';
// import 'package:tailor_clothing_application/widgets/service_card.dart';

// class CatalogHomeScreen extends StatefulWidget {
//   const CatalogHomeScreen({super.key});

//   @override
//   State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
// }

// class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
//   String category = 'men';

//   @override
//   void initState() {
//     super.initState();
//     final provider = Provider.of<CatalogProvider>(context, listen: false);
//     provider.fetchServices(category);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CatalogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product & Service Catalog"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.cloud_upload_outlined),
//             onPressed: () {
//               Navigator.pushNamed(context, '/upload-design');
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (val) {
//               setState(() => category = val);
//               provider.fetchServices(val);
//             },
//             itemBuilder: (_) => const [
//               PopupMenuItem(value: 'men', child: Text("Men")),
//               PopupMenuItem(value: 'women', child: Text("Women")),
//               PopupMenuItem(value: 'kids', child: Text("Kids")),
//             ],
//           ),
//         ],
//       ),
//       body: provider.loading
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: provider.services.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.8,
//               ),
//               itemBuilder: (context, i) {
//                 final service = provider.services[i];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ServiceDetailScreen(service: service),
//                       ),
//                     );
//                   },
//                   child: ServiceCard(service: service),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/screens/catalog/service_detail_screen.dart';
import 'package:tailor_clothing_application/widgets/service_card.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key});

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
  String category = 'men';

  @override
  void initState() {
    super.initState();

    // ✅ FIX: Delay provider call until after first frame to avoid "setState during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CatalogProvider>(context, listen: false);
      provider.fetchServices(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product & Service Catalog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/upload-design');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() => category = val);
              provider.fetchServices(val);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'men', child: Text("Men")),
              PopupMenuItem(value: 'women', child: Text("Women")),
              PopupMenuItem(value: 'kids', child: Text("Kids")),
            ],
          ),
        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: provider.services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, i) {
                final service = provider.services[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(service: service),
                      ),
                    );
                  },
                  child: ServiceCard(service: service),
                );
              },
            ),
    );
  }
}
