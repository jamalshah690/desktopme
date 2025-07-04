class TodoModel {
  final int? id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int userId; // 👈 Add this

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      createdAt:  map['createdAt'],
      updatedAt:  map['updatedAt'],
      userId: map['userId'], // 👈 parse it
    );
  }

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
    int? userId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}