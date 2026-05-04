import '../models/story.dart';
import '../repositories/story_repository.dart';

class StoryController {
  final StoryRepository repository;

  List<Story> stories = [];

  StoryController(this.repository);

  Future<void> loadStories() async {
    stories = await repository.loadStories();
  }

  Future<void> addStory(Story story) async {
    stories.add(story);
    await repository.saveStories(stories);
  }

  Future<void> deleteStory(int id) async {
    stories.removeWhere((s) => s.id == id);
    await repository.deleteStory(id);
  }

  Future<void> update() async {
    await repository.saveStories(stories);
  }
}