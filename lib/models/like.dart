class Like {
  final String userId;
  final String documentId;
  final DateTime time;

  Like({
    required this.userId,
    required this.documentId,
    required this.time,
  });

  // Convert a Like object to a map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'document_id': documentId,
      'time': time.toIso8601String(),
    };
  }

  // Create a Like object from a map (e.g., from Supabase)
  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      userId: map['user_id'],
      documentId: map['document_id'],
      time: DateTime.parse(map['time']),
    );
  }
}