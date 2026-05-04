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

  void editText() {
    final controller =
    TextEditingController(text: currentPage.textContent);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✏️ Edit Page"),
        content: TextField(
          controller: controller,
          maxLines: 6,
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

  Future<void> pickImage() async {
    final image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        currentPage.imagePath = image.path;
      });
      widget.onUpdate();
    }
  }
  @override
  Widget build(BuildContext context) {
    final page = currentPage;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Page ${currentIndex + 1} of ${widget.story.pages.length}",
          style: const TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(onPressed: pickImage, icon: const Icon(Icons.image)),
          IconButton(onPressed: editText, icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== IMAGE =====
            if (page.imagePath != null &&
                File(page.imagePath!).existsSync())
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.file(
                    File(page.imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: const Icon(Icons.image, size: 80),
              ),
            const SizedBox(height: 20),
            // ===== TEXT =====
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    page.textContent,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ===== NAV BUTTONS =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () => setState(() => currentIndex--)
                      : null,
                  child: const Text("⬅ Previous"),
                ),
                ElevatedButton(
                  onPressed: currentIndex <
                      widget.story.pages.length - 1
                      ? () => setState(() => currentIndex++)
                      : null,
                  child: const Text("Next ➡"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}