/// Domain entity: what a post IS in our app. Pure Dart, no Firebase and no
/// JSON code (that lives in PostModel, in the data layer).
class Post {
  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
}
