class News {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishDate;
  final String category;
  final bool isUrgent;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishDate,
    required this.category,
    this.isUrgent = false,
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      publishDate: DateTime.parse(map['publishDate']),
      category: map['category'],
      isUrgent: map['isUrgent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'publishDate': publishDate.toIso8601String(),
      'category': category,
      'isUrgent': isUrgent,
    };
  }
}
