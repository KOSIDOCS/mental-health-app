class ArticleModel {
  final String picture;
  final String name;
  final int minRead;
  final String date;
  final String id;
  final String body;
  final String authorId;
  // final List<dynamic> comments;
  final List<CommentsModel> comments;

  ArticleModel({
    required this.picture,
    required this.name,
    required this.minRead,
    required this.date,
    required this.id,
    required this.body,
    required this.authorId,
    // required this.comments,
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
      //comments: map['comments'] ?? [],
      comments: map['comments'] != null
      ? List<CommentsModel>.from(
          map['comments']?.map((p) => CommentsModel.fromMap(p)))
      : [],
    );
  }
}

class CommentsModel {
  final String author;
  final String authorId;
  final String date;
  final String picture;
  final String text;
  final List<SubCommentsModel> subComments;

  CommentsModel({
    required this.author,
    required this.authorId,
    required this.date,
    required this.picture,
    required this.text,
    required this.subComments,
  });

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      author: map['author'] ?? "",
      authorId: map['author_id'] ?? "",
      date: map['date'] ?? "",
      picture: map['picture'] ?? "",
      text: map['text'] ?? "",
      subComments: map['sub_comments'] != null
      ? List<SubCommentsModel>.from(
          map['sub_comments']?.map((p) => SubCommentsModel.fromMap(p)))
      : [],
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'author': author,
      'author_id': authorId,
      'date': date,
      'picture': picture,
      'text': text,
      'sub_comments': List<Map<String, dynamic>>.from(
        subComments.map((x) => x.toMap())
      ),
    };
  }
}

class SubCommentsModel {
  final String author;
  final String authorId;
  final String date;
  final String picture;
  final String text;

  SubCommentsModel({
    required this.author,
    required this.authorId,
    required this.date,
    required this.picture,
    required this.text,
  });

  factory SubCommentsModel.fromMap(Map<String, dynamic> map) {
    return SubCommentsModel(
      author: map['author'] ?? "",
      authorId: map['author_id'] ?? "",
      date: map['date'] ?? "",
      picture: map['picture'] ?? "",
      text: map['text'] ?? "",
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'author': author,
      'author_id': authorId,
      'date': date,
      'picture': picture,
      'text': text,
    };
  }
}