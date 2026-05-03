import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/story.dart';
import '../models/story_page.dart';

class PageScreen extends StatefulWidget {
  final Story story;
  final int initialIndex;
  final VoidCallback onUpdate;

  const PageScreen({
    super.key,
    required this.story,
    required this.initialIndex,
    required this.onUpdate,
  });

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  late int currentIndex;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  StoryPage get currentPage => widget.story.pages[currentIndex];

  // ===== Edit Page Text =====
  void editText() {
    final controller =
    TextEditingController(text: currentPage.textContent);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✏️ Edit Page Text"),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentPage.textContent = controller.text;
              });
              widget.onUpdate();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ===== Pick Image =====
  Future<void> pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        currentPage.imagePath = image.path;
      });
      widget.onUpdate();
    }
  }

  // ===== Navigation =====
  void nextPage() {
    if (currentIndex < widget.story.pages.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = currentPage;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          "${widget.story.title} 📖",
          style: const TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: "Add Image",
            onPressed: pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Text",
            onPressed: editText,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Page Counter =====
            Text(
              "Page ${currentIndex + 1} of ${widget.story.pages.length}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 15),

            // ===== Image =====
            if (page.imagePath != null &&
                File(page.imagePath!).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(page.imagePath!),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.orange,
                ),
              ),

            const SizedBox(height: 20),

            // ===== Text Content =====
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Text(
                      page.textContent,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== Navigation Buttons =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                ),
                ElevatedButton.icon(
                  onPressed: nextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}