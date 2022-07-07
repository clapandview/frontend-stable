class User {
  String id;
  String phone;
  String name;
  String username;
  int age;
  List following;
  // ignore: non_constant_identifier_names
  int following_count;
  // ignore: non_constant_identifier_names
  int followers_count;
  String description;
  String link;
  // ignore: non_constant_identifier_names
  List fav_hashtags;
  // ignore: non_constant_identifier_names
  String profile_pic;
  String gender;
  // ignore: non_constant_identifier_names
  List gender_preference;
  // ignore: non_constant_identifier_names
  String datetime_registration;
  String balance;
  String email;

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.username,
    required this.age,
    required this.following,
    // ignore: non_constant_identifier_names
    required this.following_count,
    // ignore: non_constant_identifier_names
    required this.followers_count,
    required this.description,
    required this.link,
    // ignore: non_constant_identifier_names
    required this.fav_hashtags,
    // ignore: non_constant_identifier_names
    required this.profile_pic,
    required this.gender,
    // ignore: non_constant_identifier_names
    required this.gender_preference,
    // ignore: non_constant_identifier_names
    required this.datetime_registration,
    required this.balance,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        phone = (map['phone'] == null) ? "" : map['phone'],
        name = (map['name'] == null) ? "" : map['name'],
        username = (map['username'] == null) ? "" : map['username'],
        age = map['age'],
        following = (map['following'] == null) ? [] : map['following'],
        following_count = map['following_count'],
        followers_count = map['followers_count'],
        description = (map['description'] == null) ? "" : map['description'],
        link = (map['link'] == null) ? "" : map['link'],
        fav_hashtags = (map['fav_hashtags'] == null) ? [] : map['fav_hashtags'],
        profile_pic = (map['profile_pic'] == null) ? "" : map['profile_pic'],
        gender = (map['gender'] == null) ? "" : map['gender'],
        gender_preference =
            (map['gender_preference'] == null) ? [] : map['gender_preference'],
        datetime_registration = map['datetime_registration'],
        balance = (map['balance'] == null) ? "" : map['balance'],
        email = (map['email'] == null) ? "" : map['email'];

  toJson(User user) {
    return {
      "_id": user.id,
      "phone": user.phone,
      "name": user.name,
      "username": user.username,
      "age": '${user.age}',
      "following": user.following,
      "following_count": '${user.following_count}',
      "followers_count": '${user.followers_count}',
      "description": user.description,
      "link": user.link,
      "fav_hashtags": user.fav_hashtags,
      "profile_pic": user.profile_pic,
      "gender": user.gender,
      "gender_preference": user.gender_preference,
      "datetime_registration": user.datetime_registration,
      "balance": user.balance,
      "email": user.email,
    };
  }
}
