class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
    };
  }
}
