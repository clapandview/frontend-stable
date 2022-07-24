import 'package:clap_and_view/client/models/meta.dart';

class Session {
  String id;
  DateTime ts;
  Meta metadata;
  double revenue;

  Session({
    required this.id,
    required this.ts,
    required this.metadata,
    required this.revenue,
  });

  Session.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        ts = map['ts'],
        metadata = Meta.fromJson(map['metadata']),
        revenue = map['revenue'];

  toJson(Session session) {
    return {
      "_id": session.id,
      "ts": session.ts,
      "metadata": session.metadata.toJson(session.metadata),
      "revenue": session.revenue,
    };
  }
}
