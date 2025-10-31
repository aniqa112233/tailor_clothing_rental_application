import 'package:flutter/material.dart';
import '../models/fabric_model.dart';

class FabricChip extends StatelessWidget {
  final FabricModel fabric;
  final bool selected;
  final VoidCallback onTap;

  const FabricChip({
    super.key,
    required this.fabric,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(fabric.name),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
