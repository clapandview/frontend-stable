class Hashtag {
  String id;
  String name;
  String emoji;
  int count;

  Hashtag({
    required this.id,
    required this.name,
    required this.emoji,
    required this.count,
  });

  Hashtag.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        emoji = map['emoji'],
        count = map['count'];

  toJson(Hashtag category) {
    return {
      "_id": category.id,
      "name": category.name,
      "emoji": category.emoji,
      "count": category.count,
    };
  }
}
