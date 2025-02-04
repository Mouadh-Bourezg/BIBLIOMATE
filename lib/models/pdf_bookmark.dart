
class PdfBookmark {
  final int pageNumber;
  final String note;
  final DateTime timestamp;

  PdfBookmark({
    required this.pageNumber,
    this.note = '',
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'note': note,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PdfBookmark.fromJson(Map<String, dynamic> json) => PdfBookmark(
    pageNumber: json['pageNumber'],
    note: json['note'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}