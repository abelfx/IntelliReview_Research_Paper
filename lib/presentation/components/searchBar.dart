import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;

  const CustomSearchBar({
    super.key,
    required this.query,
    required this.onQueryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onQueryChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),  // more rounded
          borderSide: BorderSide.none,              // no border line
        ),
        filled: true,
        fillColor: const Color(0xFFECECFB),         // same background color as dropdown
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
