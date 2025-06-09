import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';
import 'package:frontend/presentation/%20viewmodels/CategoryStateNotifier.dart';

class CategoryViewScreen extends ConsumerStatefulWidget {
  const CategoryViewScreen({super.key});

  @override
  ConsumerState<CategoryViewScreen> createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends ConsumerState<CategoryViewScreen> {
  String searchQuery = '';

  final Map<String, IconData> categoryIcons = {
    'food': Icons.restaurant,
    'travel': Icons.flight,
    'shopping': Icons.shopping_cart,
    'work': Icons.work,
    'home': Icons.home,
    'default': Icons.category,
  };

  IconData getCategoryIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    return categoryIcons[lowerName] ??
        categoryIcons.entries.firstWhere(
          (entry) => lowerName.contains(entry.key),
          orElse: () => MapEntry('default', Icons.category),
        ).value;
  }

  void showEditDialog(Categoryentities category) {
    final nameCtrl = TextEditingController(text: category.name);
    final descCtrl = TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(categoryNotifierProvider.notifier).editCategory(
                    category.id,
                    nameCtrl.text.trim(),
                    descCtrl.text.trim(),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Category updated successfully")),
              );
            },
            child: const Text("Update"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

 void showDeleteDialog(Categoryentities category) {
  print("Deleting category with ID: '${category.id}'"); // 👈 Log it

  if (category.id.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid category ID")),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Confirm Deletion"),
      content: Text("Are you sure you want to delete '${category.name}'?"),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ref
                .read(categoryNotifierProvider.notifier)
                .removeCategory(category.id.trim());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Category deleted successfully")),
            );
          },
          child: const Text("Delete", style: TextStyle(color: Color(0xFF8786E8))),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: const InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: categoryState.when(
              data: (categories) {
                final filtered = categories
                    .where((cat) =>
                        cat.name.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No categories found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final category = filtered[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: const Color(0xFF8786E8), width: 2),
                              ),
                              child: Icon(
                                getCategoryIcon(category.name),
                                color: const Color(0xFF8786E8),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.black),
                                            onPressed: () =>
                                                showEditDialog(category),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.black),
                                            onPressed: () =>
                                                showDeleteDialog(category),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.description,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
