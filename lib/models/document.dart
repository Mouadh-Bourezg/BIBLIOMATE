class Document {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String pdfContentUrl;
  final DateTime? publishDate;
  final String? uploaderId;
  final int likes;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pdfContentUrl,
    this.publishDate,
    required this.uploaderId,
    required this.likes,
  });

  // Factory method to create a Document from a map (e.g., from a database query)
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['image_url'],
      pdfContentUrl: map['pdf_content_url'],
      publishDate: map['publish_date'] != null ? DateTime.parse(map['publish_date']) : null,
      uploaderId: map['uploader_id'],
      likes: map['likes'],
    );
  }

  // Method to convert a Document to a map (e.g., for inserting into the database)
  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'pdf_content_url': pdfContentUrl,
      'publish_date': (publishDate?.toIso8601String())!,
      'uploader_id': uploaderId!,
      'likes': likes,
    };
  }
}