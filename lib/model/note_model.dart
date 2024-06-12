class Note {
  String id;
  String subtitle;
  String title;
  String time;
  int image;
  bool isDone;
  final DateTime date; // New date field
  final DateTime createdAt;
  late final DateTime updatedAt;

  Note(this.id, this.subtitle, this.title, this.time, this.image, this.isDone,
      this.date, this.createdAt, this.updatedAt);
}
