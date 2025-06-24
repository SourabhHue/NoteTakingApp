class Note {
  String title;
  String content;
  DateTime timestamp;

  Note({
    required this.title,
    required this.content,
  }) : timestamp = DateTime.now();
}