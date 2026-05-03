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
      textContent: 'New page text',
    );

    widget.story.addPage(page);
    widget.onUpdate();
    setState(() {});
  }

  void deletePage(int index) {
    widget.story.pages.removeAt(index);
    widget.onUpdate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: ListView.builder(
        itemCount: widget.story.pages.length,
        itemBuilder: (context, index) {
          final page = widget.story.pages[index];
          return ListTile(
            title: Text('Page ${page.pageNumber}'),
            subtitle: Text(
              page.textContent.length > 30
                  ? page.textContent.substring(0, 30)
                  : page.textContent,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deletePage(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageScreen(
                    story: widget.story,
                    initialIndex: index,
                    onUpdate: widget.onUpdate,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}