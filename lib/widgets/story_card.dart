import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.orange),
        title: Text(story.title),
        subtitle: Text("Pages: ${story.pages.length}"),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}