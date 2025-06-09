import 'package:flutter/material.dart';

class FilterSortCategory extends StatelessWidget {
  final String? selectedFilter;
  final String? selectedSort;
  final String? selectedCategory;
  final void Function(String) onFilterSelected;
  final void Function(String) onSortSelected;
  final void Function(String) onCategorySelected;

  const FilterSortCategory({
    Key? key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.selectedSort,
    required this.onSortSelected,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const filterOptions = ['All', 'Favorites', 'Recent'];
    const sortOptions = ['Name', 'Date', 'Rating'];
    const categoryOptions = ['General', 'Work', 'Personal', 'Urgent'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Filter ──
          Expanded(
            child: _StyledDropdown(
              hint: 'Filter',
              value: selectedFilter,
              items: filterOptions,
              onChanged: onFilterSelected,
            ),
          ),
          const SizedBox(width: 8),
          // ── Sort ──
          Expanded(
            child: _StyledDropdown(
              hint: 'Sort',
              value: selectedSort,
              items: sortOptions,
              onChanged: onSortSelected,
            ),
          ),
          const SizedBox(width: 8),
          // ── Category ──
          Expanded(
            child: _StyledDropdown(
              hint: 'Category',
              value: selectedCategory,
              items: categoryOptions,
              onChanged: onCategorySelected,
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
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFECECFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
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
