import 'dart:async';

import 'package:clap_and_view/client/models/group.dart';
import 'package:clap_and_view/client/models/message.dart';
import 'package:clap_and_view/client/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseApi extends ChangeNotifier {
  static const int pageLimit = 20;
  int chatPage = 0;

  static Future uploadMessage(String idGroup, Message message) async {
    final refMessage =
        FirebaseFirestore.instance.collection('message/$idGroup/messages');
    await refMessage.add(message.toJson());

    final refGroup = FirebaseFirestore.instance.collection('group');
    await refGroup.doc(idGroup).update({
      "last_message_text": message.message_text,
      "id_user_sent": message.id_user,
      "modified_at": Utils.fromDateTimeToJson(message.sent_at!)
    });
  }

  static Stream<List<Message>> loadChat(String idGroup) {
    return FirebaseFirestore.instance
        .collection('message/$idGroup/messages')
        .orderBy(MessageField.sent_at, descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }

  static Stream<List<Message>> loadStreamChat(String idGroup) {
    return FirebaseFirestore.instance
        .collection('message/$idGroup/messages')
        .where("sent_at",
            isGreaterThan: DateTime.now().subtract(const Duration(seconds: 30)))
        .orderBy(MessageField.sent_at, descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }

  // ignore: non_constant_identifier_names
  static Stream<List<Group>> getGroupByListIdUser(List<String> user_ids) {
    var raw = FirebaseFirestore.instance
        .collection('group')
        .where("members_ids", isEqualTo: user_ids)
        .snapshots()
        .transform(Utils.transformer(Group.fromJson));
    return raw;
  }

  static Stream<List<Group>> getGroupByIdStream(String streamId) {
    var raw = FirebaseFirestore.instance
        .collection('group')
        .where("stream_id", isEqualTo: streamId)
        .snapshots()
        .transform(Utils.transformer(Group.fromJson));
    return raw;
  }

  static Future createGroup(Group group) async {
    final refMessages = FirebaseFirestore.instance.collection('group');
    await refMessages.add(group.toJson());
  }

  static Stream<List<Group>> getGroupsByUserId(String idUser) {
    var raw = FirebaseFirestore.instance
        .collection('group')
        .where("type", isEqualTo: 1)
        .where("members_ids", arrayContains: idUser)
        .orderBy(GroupField.modified_at, descending: true)
        .snapshots()
        .transform(Utils.transformer(Group.fromJson));
    return raw;
  }

  static Stream<List<Group>> getGroups() {
    var raw = FirebaseFirestore.instance
        .collection('group')
        .snapshots()
        .transform(Utils.transformer(Group.fromJson));
    return raw;
  }
}
