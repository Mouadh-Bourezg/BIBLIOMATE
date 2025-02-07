class Save {
  final int? id;
  final int listId;
  final int documentId;

  Save({
    this.id,
    required this.listId,
    required this.documentId,
  });

  // Convert a Save object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'bookId': documentId,
    };
  }

  // Create a Save object from a Map
  factory Save.fromMap(Map<String, dynamic> map) {
    return Save(
      id: map['id']?? null,
      listId: map['list_id'],
      documentId: map['document_id'],
    );
  }

  @override
  String toString() {
    return 'Save{id: $id, listId: $listId, bookId: $documentId}';
  }
}
