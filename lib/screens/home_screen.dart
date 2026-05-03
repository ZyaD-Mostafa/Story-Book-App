import 'package:flutter/material.dart';
import '../models/story.dart';
import '../storage/story_storage.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Story> stories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  void loadStories() async {
    stories = await StoryStorage.loadStories();
    setState(() {
      isLoading = false;
    });
  }

  void addStory() async {
    final newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'New Story',
      author: 'Student',
      createdAt: DateTime.now(),
      pages: [],
    );

    stories.add(newStory);
    await StoryStorage.saveStories(stories);
    setState(() {});
  }

  void deleteStory(int index) async {
    stories.removeAt(index);
    await StoryStorage.saveStories(stories);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Storybook Creator')),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.book, size: 40, color: Colors.deepPurple),
              title: Text(
                story.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Pages: ${story.getPageCount()}',
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoryDetailScreen(
                      story: story,
                      onUpdate: () async {
                        await StoryStorage.saveStories(stories);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addStory,
        child: const Icon(Icons.add),
      ),
    );
  }
}