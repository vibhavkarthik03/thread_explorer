class Comment {
  final int id;
  final String author;
  final String text;
  final List<Comment> children;
  bool isExpanded;
  int depth;
  final String createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    this.children = const [],
    this.isExpanded = false,
    this.depth = 0,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      createdAt: json["created_at"],
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      text: json['text'] ?? '',
      children: (json['children'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
      isExpanded: json['isExpanded'] ?? true,
      depth: json['depth'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'text': text,
      'children': children.map((c) => c.toJson()).toList(),
      'isExpanded': isExpanded,
      'depth': depth,
    };
  }
}
