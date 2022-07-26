import '../utils/utils.dart';

class MessageField {
  static const String sent_at = 'sent_at';
}

class Message {
  String id_user;
  String message_text;
  String username;
  DateTime? sent_at;

  Message({
    required this.id_user,
    required this.message_text,
    required this.username,
    required this.sent_at,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        id_user: json['id_user_sent'],
        message_text: json['message_text'],
        username: json['username'],
        sent_at: Utils.toDateTime(json['sent_at']),
      );

  Map<String, dynamic> toJson() => {
        'id_user_sent': id_user,
        'message_text': message_text,
        'username': username,
        'sent_at': Utils.fromDateTimeToJson(sent_at!),
      };
}
