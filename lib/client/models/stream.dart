class StreamModel {
  String id;
  // ignore: non_constant_identifier_names
  String user_id;
  String title;
  // ignore: non_constant_identifier_names
  String author_name;
  // ignore: non_constant_identifier_names
  String author_username;
  // ignore: non_constant_identifier_names
  List<dynamic> hashtag_list;
  String description;
  String link;
  String thumbnail;
  int count;
  int status;
  // ignore: non_constant_identifier_names
  double smart_score;
  // ignore: non_constant_identifier_names
  List<dynamic> restricted_phone_list;
  // ignore: non_constant_identifier_names
  List<dynamic> restricted_country_list;

  StreamModel({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.user_id,
    required this.title,
    // ignore: non_constant_identifier_names
    required this.author_name,
    // ignore: non_constant_identifier_names
    required this.author_username,
    // ignore: non_constant_identifier_names
    required this.hashtag_list,
    required this.description,
    required this.link,
    required this.thumbnail,
    required this.count,
    required this.status,
    // ignore: non_constant_identifier_names
    required this.smart_score,
    // ignore: non_constant_identifier_names
    required this.restricted_phone_list,
    // ignore: non_constant_identifier_names
    required this.restricted_country_list,
  });

  StreamModel.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        user_id = map['user_id'],
        title = map['title'],
        author_name = map['author_name'],
        author_username = map['author_username'],
        hashtag_list = map['hashtag_list'],
        description = map['description'],
        link = map['link'],
        thumbnail = (map['thumbnail'] == null) ? "" : map['thumbnail'],
        count = map['count'],
        status = map['status'],
        smart_score = map['smart_score'],
        restricted_phone_list = map['restricted_phone_list'],
        restricted_country_list = map['restricted_country_list'];

  toJson(StreamModel stream) {
    return {
      "_id": stream.id,
      "user_id": stream.user_id,
      "title": stream.title,
      "author_name": stream.author_name,
      "author_username": stream.author_username,
      "hashtag_list": stream.hashtag_list,
      "description": stream.description,
      "link": stream.link,
      "thumbnail": stream.thumbnail,
      "count": stream.count,
      "status": stream.status,
      "smart_score": stream.smart_score,
      "restricted_phone_list": stream.restricted_phone_list,
      "restricted_country_list": stream.restricted_country_list,
    };
  }
}
