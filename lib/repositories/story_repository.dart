import '../models/story.dart';

abstract class StoryRepository {
  Future<List<Story>> loadStories();
  Future<void> saveStories(List<Story> stories);
  Future<void> saveStory(Story story);
  Future<void> deleteStory(int id);
}