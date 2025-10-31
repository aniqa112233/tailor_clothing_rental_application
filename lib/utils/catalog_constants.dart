import 'package:flutter/material.dart';

/// 🔹 Category Tabs
const List<String> kServiceCategories = ['men', 'women', 'kids'];

/// 🔹 Supabase Bucket Names
const String kDesignBucket = 'designs';
const String kFabricBucket = 'fabrics';
const String kTemplateBucket = 'templates';
const String kRentalBucket = 'rentals';

/// 🔹 App Colors (for catalog screens)
const Color kPrimaryColor = Colors.blueAccent;
const Color kSecondaryColor = Colors.deepPurpleAccent;

/// 🔹 Fallback Images
const String kDefaultImage =
    'https://via.placeholder.com/300x200.png?text=No+Image';

/// 🔹 Static pricing model (for demo)
const Map<String, double> kBasePricing = {
  'shirt': 1500.0,
  'shalwar_kameez': 2000.0,
  'lehenga': 3500.0,
};

/// 🔹 Fabric price multipliers
const Map<String, double> kFabricPriceMultiplier = {
  'cotton': 1.0,
  'silk': 1.5,
  'linen': 1.2,
  'velvet': 1.8,
};
