import 'dart:convert';

class ReviewRequestModel {
  final int rating;
  final String? comment;

  ReviewRequestModel({required this.rating, this.comment});

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }

  String toJson() => json.encode(toMap());
}