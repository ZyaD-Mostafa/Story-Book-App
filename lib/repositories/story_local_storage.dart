import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';
import 'story_repository.dart';

class StoryLocalStorage implements StoryRepository {
  static const String key = "stories";

  @override
  Future<List<Story>> loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);

    return decoded.map((e) => Story.fromJson(e)).toList();
  }

  @override
  Future<void> saveStories(List<Story> stories) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonData = jsonEncode(
      stories.map((s) => s.toJson()).toList(),
    );

    await prefs.setString(key, jsonData);
  }

  @override
  Future<void> saveStory(Story story) async {
    final stories = await loadStories();

    stories.removeWhere((s) => s.id == story.id);
    stories.add(story);

    await saveStories(stories);
  }

  @override
  Future<void> deleteStory(int id) async {
    final stories = await loadStories();

    stories.removeWhere((s) => s.id == id);

    await saveStories(stories);
  }
}