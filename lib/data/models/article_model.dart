import 'source_model.dart';

/// Article model for news articles
class Article {
  final String title;
  final String? description;
  final String? content;
  final String url;
  final String? image;
  final String publishedAt;
  final Source source;

  Article({
    required this.title,
    this.description,
    this.content,
    required this.url,
    this.image,
    required this.publishedAt,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String? ?? '',
      image: json['image'] as String?,
      publishedAt:
          json['publishedAt'] as String? ?? DateTime.now().toIso8601String(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'image': image,
      'publishedAt': publishedAt,
      'source': source.toJson(),
    };
  }

  /// Create a copy with optional field updates
  Article copyWith({
    String? title,
    String? description,
    String? content,
    String? url,
    String? image,
    String? publishedAt,
    Source? source,
  }) {
    return Article(
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      url: url ?? this.url,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'Article(title: $title, source: ${source.name}, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
