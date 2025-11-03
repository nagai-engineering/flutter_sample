class Task {
  final int? id;
  final String text;
  final bool completed;
  final String date; // YYYY-MM-DD format
  final DateTime createdAt;

  Task({
    this.id,
    required this.text,
    required this.completed,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Task to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'completed': completed ? 1 : 0,
      'date': date,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      text: map['text'] as String,
      completed: (map['completed'] as int) == 1,
      date: map['date'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Copy with method for updating tasks
  Task copyWith({
    int? id,
    String? text,
    bool? completed,
    String? date,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, text: $text, completed: $completed, date: $date}';
  }
}
