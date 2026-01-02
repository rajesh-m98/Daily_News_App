/// Source model for news articles
class Source {
  final String? name;
  final String? url;

  Source({this.name, this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(name: json['name'] as String?, url: json['url'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }

  @override
  String toString() {
    return 'Source(name: $name, url: $url)';
  }
}
