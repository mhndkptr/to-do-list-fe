class Todo {
  final int id;
  final String todo;
  final String description;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.todo,
    required this.description,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      description: json['description'],
      isCompleted: json['isCompleted'],
    );
  }
}
