class ListModel {
  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Document to Map<String, String>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create Document from Map
  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'] as String,
      title: map['title'] as String,
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}