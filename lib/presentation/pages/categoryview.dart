import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ viewmodels/category_bloc.dart';

import '../../model/category_model.dart';

class CategoryViewScreen extends StatefulWidget {
  const CategoryViewScreen({super.key});

  @override
  State<CategoryViewScreen> createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends State<CategoryViewScreen> {
  String searchQuery = '';
  CategoryModel? editingCategory;
  CategoryModel? deletingCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  void showEditDialog(CategoryModel category) {
    final nameCtrl = TextEditingController(text: category.name);
    final descCtrl = TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CategoryBloc>().add(EditCategoryEvent(
                categoryId: category.categoryId,
                name: nameCtrl.text,
                description: descCtrl.text,
              ));
            },
            child: const Text("Update"),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }

  void showDeleteDialog(CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete '${category.name}'?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CategoryBloc>().add(DeleteCategoryEvent(category.categoryId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Category deleted successfully")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) {
                setState(() => searchQuery = val);
                context.read<CategoryBloc>().add(SearchCategoryEvent(val));
              },
              decoration: const InputDecoration(labelText: "Search", border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryLoadedState) {
                  final filtered = state.categories;
                  if (filtered.isEmpty) return const Center(child: Text("No categories found"));
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final category = filtered[i];
                      return ListTile(
                        title: Text(category.name),
                        subtitle: Text(category.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => showEditDialog(category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDeleteDialog(category),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
