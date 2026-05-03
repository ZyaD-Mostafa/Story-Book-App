import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';

class StoryStorage {
  static const String _key = 'stories';

  static Future<void> saveStories(List<Story> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
    jsonEncode(stories.map((s) => s.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<List<Story>> loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Story.fromJson(e)).toList();
  }
}