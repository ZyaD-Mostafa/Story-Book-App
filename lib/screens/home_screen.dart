import 'package:book_story_final/widgets/story_card.dart';
import 'package:flutter/material.dart';
import '../models/story.dart';
import '../controllers/story_controller.dart';
import '../repositories/story_local_storage.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StoryController controller;
  bool isLoading = true;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller = StoryController(StoryLocalStorage());
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    await controller.loadStories();
    setState(() => isLoading = false);
  }

  List<Story> get filteredStories {
    if (searchQuery.isEmpty) {
      return controller.stories;
    }

    return controller.stories
        .where((story) =>
        story.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void deleteStory(int id) async {
    await controller.deleteStory(id);
    setState(() {});
  }

  void showCreateDialog() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create Story 📖"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Story title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final story = Story(
                id: DateTime.now().millisecondsSinceEpoch,
                title: textController.text.isEmpty
                    ? "Untitled"
                    : textController.text,
                author: "Student",
                createdAt: DateTime.now(),
                pages: [],
              );

              await controller.addStory(story);
              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 My Stories"),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search stories...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: filteredStories.isEmpty
          ? const Center(child: Text("No stories found"))
          : ListView.builder(
        itemCount: filteredStories.length,
        itemBuilder: (context, index) {
          final story = filteredStories[index];

          return StoryCard(
            story: story,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryDetailScreen(
                    story: story,
                    onUpdate: () async {
                      await controller.update();
                      setState(() {});
                    },
                  ),
                ),
              );
            },
            onDelete: () => deleteStory(story.id),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text("Create Story"),
      ),
    );
  }
}