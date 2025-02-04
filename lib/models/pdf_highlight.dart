import 'package:flutter/material.dart';

class PdfHighlight {
  final int pageNumber;
  final Rect bounds;
  final String text;
  final Color color;

  PdfHighlight({
    required this.pageNumber,
    required this.bounds,
    required this.text,
    this.color = Colors.yellow,
  });

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'bounds': {
          'left': bounds.left,
          'top': bounds.top,
          'right': bounds.right,
          'bottom': bounds.bottom,
        },
        'text': text,
        'color': color.value,
      };

  factory PdfHighlight.fromJson(Map<String, dynamic> json) => PdfHighlight(
        pageNumber: json['pageNumber'],
        bounds: Rect.fromLTRB(
          json['bounds']['left'],
          json['bounds']['top'],
          json['bounds']['right'],
          json['bounds']['bottom'],
        ),
        text: json['text'],
        color: Color(json['color']),
      );
}
