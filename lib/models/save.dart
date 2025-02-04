class Save {
  final int? id;
  final int listId;
  final int bookId;

  Save({
    this.id,
    required this.listId,
    required this.bookId,
  });

  // Convert a Save object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'bookId': bookId,
    };
  }

  // Create a Save object from a Map
  factory Save.fromMap(Map<String, dynamic> map) {
    return Save(
      id: map['id'],
      listId: map['listId'],
      bookId: map['bookId'],
    );
  }

  @override
  String toString() {
    return 'Save{id: $id, listId: $listId, bookId: $bookId}';
  }
}
