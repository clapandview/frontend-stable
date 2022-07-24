class Meta {
  int status;
  // ignore: non_constant_identifier_names
  String user_id;
  // ignore: non_constant_identifier_names
  String stream_id;

  Meta({
    required this.status,
    // ignore: non_constant_identifier_names
    required this.user_id,
    // ignore: non_constant_identifier_names
    required this.stream_id,
  });

  Meta.fromJson(Map<String, dynamic> map)
      : status = map['status'],
        user_id = map['user_id'],
        stream_id = map['stream_id'];

  toJson(Meta meta) {
    return {
      "status": meta.status,
      "user_id": meta.user_id,
      "stream_id": meta.stream_id,
    };
  }
}
