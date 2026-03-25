class BlogDto {
  final int blogId;
  final int? userId;
  final String title;
  final String content;
  final DateTime? createdAt;

  const BlogDto({
    required this.blogId,
    this.userId,
    required this.title,
    required this.content,
    this.createdAt,
  });

  factory BlogDto.fromJson(Map<String, dynamic> json) {
    return BlogDto(
      blogId: json['blogId'] as int? ?? json['BlogId'] as int? ?? 0,
      userId: json['userId'] as int? ?? json['UserId'] as int?,
      title: json['title'] as String? ?? json['Title'] as String? ?? '',
      content: json['content'] as String? ?? json['Content'] as String? ?? '',
      createdAt: _parseDate(json['createdAt'] ?? json['CreatedAt']),
    );
  }
}

class CreateBlogRequest {
  final int? userId;
  final String title;
  final String content;

  const CreateBlogRequest({
    this.userId,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
    };
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
