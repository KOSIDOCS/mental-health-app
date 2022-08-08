class ArticleModel {
  final String picture;
  final String name;
  final int minRead;
  final String date;
  final String id;
  final String body;

  ArticleModel({
    required this.picture,
    required this.name,
    required this.minRead,
    required this.date,
    required this.id,
    required this.body,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return ArticleModel(
      picture: map['picture'] ?? "",
      name: map['name'] ?? "",
      minRead: int.parse(map['min_read']),
      date: map['date'] ?? "",
      id: uid,
      body: map['body'] ?? "",
    );
  }
}