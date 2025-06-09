import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

// <-- import your providers
import '../../application/providers/paper_provider.dart';
import '../../application/providers/user_provider.dart';

class PostingScreen extends ConsumerStatefulWidget {
  const PostingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends ConsumerState<PostingScreen> {
  String researchTitle = '';
  String authorsText = '';
  String selectedCategory = '';
  File? selectedFile;
  final List<String> categories = ['AI', 'Maths', 'Programming'];

  Future<void> pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to pick file: $e");
    }
  }

  Future<void> postPaper() async {
    if (researchTitle.isEmpty ||
        authorsText.isEmpty ||
        selectedCategory.isEmpty ||
        selectedFile == null) {
      Fluttertoast.showToast(msg: "Fill all fields & choose a PDF");
      return;
    }

    const userid = "1234342";

    final useCase = ref.read(paperUseCaseProvider);
    Fluttertoast.showToast(msg: "Uploading…");
    try {
      await useCase.uploadPaper(
        researchTitle,
        authorsText.split(',').map((s) => s.trim()).toList(),
        DateTime.now().year,
        userid,
        selectedCategory,
        selectedFile!.path,
      );

      Fluttertoast.showToast(msg: "Upload successful!");
      ref.read(paperNotifierProvider.notifier).fetchPapers();
      context.go('/home');
    } catch (e) {
      Fluttertoast.showToast(msg: "Upload failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Placeholder image at the top
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: Image.asset(
              'assets/placeholder.png',
              fit: BoxFit.cover,
            ),
          ),

          // Existing header + form
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  // your existing decoration if any
                  ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Research Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => researchTitle = v,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Authors (comma separated)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => authorsText = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFECECFB),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedCategory.isEmpty ? null : selectedCategory,
                      hint: const Text('Choose category'),
                      items: categories
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedCategory = v!),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: pickPDF,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        selectedFile == null ? 'Upload PDF' : 'Change PDF',
                      ),
                    ),
                    if (selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected: ${selectedFile!.path.split('/').last}',
                        ),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: postPaper,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('POST'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
