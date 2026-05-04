import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/story_page.dart';
import 'page_screen.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;
  final VoidCallback onUpdate;

  const StoryDetailScreen({
    super.key,
    required this.story,
    required this.onUpdate,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  void addPage() {
    final page = StoryPage(
      pageNumber: widget.story.pages.length + 1,
      textContent: 'Write your story here...',
    );

    setState(() {
      widget.story.addPage(page);
    });

    widget.onUpdate();
  }

  void deletePage(int index) {
    setState(() {
      widget.story.pages.removeAt(index);
    });

    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),

      // ✅ Floating Action Button with Label
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPage,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Page",
          style: TextStyle(fontSize: 18),
        ),
      ),

      body: widget.story.pages.isEmpty
          ? const Center(
        child: Text(
          "No pages yet 📄\nAdd a new page!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      )
          : ListView.builder(
        itemCount: widget.story.pages.length,
        itemBuilder: (context, index) {
          final page = widget.story.pages[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                "Page ${page.pageNumber}",
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                page.textContent.length > 30
                    ? page.textContent.substring(0, 30)
                    : page.textContent,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePage(index),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PageScreen(
                      story: widget.story,
                      initialIndex: index,
                      onUpdate: widget.onUpdate,
                    ),
                  ),
                );

                // 🔄 refresh after return
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}