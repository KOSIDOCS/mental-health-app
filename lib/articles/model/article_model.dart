class ArticleModel {
  final String picture;
  final String name;
  final int minRead;
  final String date;
  final String id;
  final String body;
  final String authorId;
  final List<dynamic> comments;

  ArticleModel({
    required this.picture,
    required this.name,
    required this.minRead,
    required this.date,
    required this.id,
    required this.body,
    required this.authorId,
    required this.comments,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return ArticleModel(
      picture: map['picture'] ?? "",
      name: map['name'] ?? "",
      minRead: int.parse(map['min_read']),
      date: map['date'] ?? "",
      id: uid,
      body: map['body'] ?? "",
      authorId: map['author_id'] ?? "",
      comments: map['comments'] ?? [],
    );
  }
}