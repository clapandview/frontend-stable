import 'package:clap_and_view/client/utils/utils.dart';

class MessageField {
  // ignore: constant_identifier_names
  static const String sent_at = 'sent_at';
}

class Message {
  // ignore: non_constant_identifier_names
  String id_user;
  // ignore: non_constant_identifier_names
  String message_text;
  String username;
  // ignore: non_constant_identifier_names
  DateTime? sent_at;

  Message({
    // ignore: non_constant_identifier_names
    required this.id_user,
    // ignore: non_constant_identifier_names
    required this.message_text,
    required this.username,
    // ignore: non_constant_identifier_names
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
