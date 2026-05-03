class StoryPage {
  int pageNumber;
  String textContent;
  String? imagePath;

  StoryPage({
    required this.pageNumber,
    required this.textContent,
    this.imagePath,
  });

  // Task 3: JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'textContent': textContent,
      'imagePath': imagePath,
    };
  }

  factory StoryPage.fromJson(Map<String, dynamic> json) {
    return StoryPage(
      pageNumber: json['pageNumber'],
      textContent: json['textContent'],
      imagePath: json['imagePath'],
    );
  }
}