import 'package:clap_and_view/client/utils/utils.dart';

class GroupField {
  // ignore: constant_identifier_names
  static const String modified_at = 'modified_at';
}

class Group {
  // ignore: non_constant_identifier_names
  String? id_creator;
  String id;
  int? type;
  String? name;
  // ignore: non_constant_identifier_names
  List<dynamic> members_ids;
  // ignore: non_constant_identifier_names
  String? id_user_sent;
  // ignore: non_constant_identifier_names
  String last_message_text;
  // ignore: non_constant_identifier_names
  String? stream_id;
  // ignore: non_constant_identifier_names
  int? members_count;
  // ignore: non_constant_identifier_names
  DateTime? modified_at;
  // ignore: non_constant_identifier_names
  DateTime? created_at;

  Group({
    // ignore: non_constant_identifier_names
    this.id_creator,
    required this.id,
    this.type,
    this.name,
    // ignore: non_constant_identifier_names
    required this.members_ids,
    // ignore: non_constant_identifier_names
    required this.last_message_text,
    // ignore: non_constant_identifier_names
    this.id_user_sent,
    // ignore: non_constant_identifier_names
    this.stream_id,
    // ignore: non_constant_identifier_names
    this.members_count,
    // ignore: non_constant_identifier_names
    this.modified_at,
    // ignore: non_constant_identifier_names
    this.created_at,
  });

  static Group fromJson(Map<String, dynamic> json) => Group(
        id_creator: (json['id_creator'] == null) ? "" : json['id_creator'],
        id: json['id'] ?? "",
        type: json['type'],
        name: (json['name'] == null) ? "" : json['name'],
        members_ids:
            (json['members_ids'] == null) ? ["1", "2"] : json['members_ids'],
        last_message_text: json['last_message_text'],
        id_user_sent: json['id_user_sent'],
        stream_id: (json['stream_id'] == null) ? "" : json['stream_id'],
        members_count: json['members_count'],
        modified_at: Utils.toDateTime(json['modified_at']),
        created_at: Utils.toDateTime(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id_creator': id_creator,
        'type': type,
        'name': name,
        'members_ids': members_ids,
        'last_message_text': last_message_text,
        // ignore: equal_keys_in_map
        'recent_message': id_user_sent,
        'stream_id': stream_id,
        'members_count': members_count,
        'modified_at': Utils.fromDateTimeToJson(modified_at!),
        'created_at': Utils.fromDateTimeToJson(created_at!),
      };
}
