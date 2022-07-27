import 'dart:io';

import 'package:clap_and_view/client/api/firebase_api.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/group.dart';
import 'package:clap_and_view/frontend/pages/home/watch_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeforeWatchStreamPage extends StatelessWidget {
  final String idCurrentStream;

  const BeforeWatchStreamPage({
    required this.idCurrentStream,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Group>>(
        stream: FirebaseApi.getGroupByIdStream(idCurrentStream),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                if (snapshot.hasData) {
                  Group group;
                  if (snapshot.data!.isNotEmpty) {
                    group = snapshot.data![0];
                    return WatchStreamPage(
                      id: idCurrentStream,
                      group: group,
                    );
                  } else {
                    FirebaseApi.createGroup(Group(
                        id: "",
                        id_creator:
                            Provider.of<UserController>(context, listen: false)
                                .currentUser
                                .id,
                        members_ids: [],
                        last_message_text: "",
                        members_count: 0,
                        type: 2,
                        name: "",
                        stream_id: Provider.of<BroadcastController>(context,
                                listen: false)
                            .currentStream
                            .id,
                        modified_at: DateTime.now(),
                        created_at: DateTime.now()));
                    return (Platform.isIOS)
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : const SizedBox(
                            height: kToolbarHeight / 2.0,
                            width: kToolbarHeight / 2.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          );
                  }
                } else {
                  return buildText("");
                }
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
