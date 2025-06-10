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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                color: Colors.grey[300],
                child: Image.asset(
                  'assets/images/welcome_page_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 24,
                child: Text(
                  'Create a Post',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // header + form
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  
                  ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'Research title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF36454F),
                            ),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFECECFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (v) => researchTitle = v,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF36454F),
                            ),
                          ),
                        ),
                        TextField(
                          maxLines: 4,
                          minLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFECECFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (v) => authorsText = v,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF36454F),
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFECECFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          value: selectedCategory.isEmpty ? null : selectedCategory,
                          hint: const Text('Choose category'),
                          items: categories
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => selectedCategory = v!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: pickPDF,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedFile == null ? 'Upload PDF' : 'Change PDF',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Icon(Icons.upload_file, size: 24),
                        ],
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
                    Center(
                      child: ElevatedButton(
                        onPressed: postPaper,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5D5CBB),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'POST',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
