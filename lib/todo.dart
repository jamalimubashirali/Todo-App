class Todo {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}
