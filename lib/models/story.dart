import 'story_page.dart';

class Story {
  int id;
  String title;
  String author;
  DateTime createdAt;
  List<StoryPage> pages;

  Story({
    required this.id,
    required this.title,
    required this.author,
    required this.createdAt,
    required this.pages,
  });

  void addPage(StoryPage page) {
    pages.add(page);
  }

  void removePage(int pageNumber) {
    pages.removeWhere((p) => p.pageNumber == pageNumber);
  }

  int getPageCount() {
    return pages.length;
  }

  // Task 3: JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'pages': pages.map((p) => p.toJson()).toList(),
    };
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      pages: (json['pages'] as List)
          .map((p) => StoryPage.fromJson(p))
          .toList(),
    );
  }
}