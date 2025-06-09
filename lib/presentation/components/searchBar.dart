import 'package:flutter/material.dart';
// In searchBar.dart
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
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}
