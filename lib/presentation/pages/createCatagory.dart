// File: lib/ui/screens/create_category_screen.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createCategory() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      // You should replace this with actual ViewModel/Bloc logic.
      Fluttertoast.showToast(msg: "Category '$name' created!");
      _nameController.clear();
      _descriptionController.clear();
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields");
    }
  }

  Widget _topImageWithText() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.asset(
          'assets/welcome_page_cropedbg.png',
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Create Category",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _topImageWithText(),
          const SizedBox(height: 24),
          _textField(label: "Category Name", controller: _nameController),
          const SizedBox(height: 24),
          _textField(
            label: "Description",
            controller: _descriptionController,
            maxLines: 5,
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _createCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: const Size(150, 50),
              ),
              child: const Text(
                "Create",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
