import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: Image.network(service.imageUrl, fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text("Rs ${service.price.toStringAsFixed(0)}"),
        ],
      ),
    );
  }
}
