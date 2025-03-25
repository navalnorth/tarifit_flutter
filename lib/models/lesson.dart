class Lesson {
  final String id;
  final String title;
  final String content;
  final String audioUrl;

  Lesson({required this.id, required this.title, required this.content, required this.audioUrl});

  factory Lesson.fromMap(Map<String, dynamic> data, String id) {
    return Lesson(
      id: id,
      title: data['title'],
      content: data['content'],
      audioUrl: data['audioUrl'],
    );
  }
}