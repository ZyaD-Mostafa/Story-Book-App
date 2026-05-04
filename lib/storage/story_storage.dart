// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/story.dart';
//
// class StoryStorage {
//   // ===== SAVE SINGLE STORY =====
//   static Future<void> saveStory(Story story) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final key = 'story_${story.id}';
//     final jsonString = jsonEncode(story.toJson());
//
//     await prefs.setString(key, jsonString);
//   }
//
//   // ===== SAVE ALL STORIES =====
//   static Future<void> saveAllStories(List<Story> stories) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     for (var story in stories) {
//       final key = 'story_${story.id}';
//       final jsonString = jsonEncode(story.toJson());
//       await prefs.setString(key, jsonString);
//     }
//   }
//
//   // ===== LOAD ALL STORIES =====
//   static Future<List<Story>> loadAllStories() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final stories = <Story>[];
//
//     for (String key in prefs.getKeys()) {
//       if (key.startsWith('story_')) {
//         final jsonString = prefs.getString(key);
//
//         if (jsonString != null) {
//           final Map<String, dynamic> json = jsonDecode(jsonString);
//           stories.add(Story.fromJson(json));
//         }
//       }
//     }
//
//     return stories;
//   }
//
//   // ===== DELETE STORY =====
//   static Future<void> deleteStory(int id) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('story_$id');
//   }
// }