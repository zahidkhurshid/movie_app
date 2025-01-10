class Review {
  final String id;
  final String author;
  final String content;
  final double rating;
  final String userId;
  final String userName;
  final String comment;

  Review({
    required this.id,
    required this.author,
    required this.content,
    required this.rating,
    required this.userId,
    required this.userName,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'rating': rating,
      'userId': userId,
      'userName': userName,
      'comment': comment,
    };
  }
}
