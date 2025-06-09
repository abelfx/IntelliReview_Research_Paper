import 'package:flutter/material.dart';

class FilterSortRow extends StatelessWidget {
  final String? selectedFilter;
  final String? selectedSort;
  final void Function(String) onFilterSelected;
  final void Function(String) onSortSelected;

  const FilterSortRow({
    Key? key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.selectedSort,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterOptions = ['All', 'Favorites', 'Recent'];
    final sortOptions = ['Name', 'Date', 'Rating'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // ── Filter ──
          Expanded(
            child: _StyledDropdown(
              value: selectedFilter,
              hint: 'Filter',
              items: filterOptions,
              onChanged: onFilterSelected,
            ),
          ),
          const SizedBox(width: 12),
          // ── Sort ──
          Expanded(
            child: _StyledDropdown(
              value: selectedSort,
              hint: 'Sort',
              items: sortOptions,
              onChanged: onSortSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String) onChanged;

  const _StyledDropdown({
    Key? key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      hint: Text(hint),
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFECECFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      items: items
          .map((option) => DropdownMenuItem<String>(
        value: option,
        child: Text(option),
      ))
          .toList(),
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}
