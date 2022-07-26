import 'package:clap_and_view/client/api/firebase_api.dart';
import 'package:clap_and_view/client/models/group.dart';
import 'package:clap_and_view/client/models/message.dart';
import 'package:flutter/material.dart';
import '../../../client/models/user.dart';
import '../../constants.dart';
import '../../logic/app_localizations.dart';
import 'message_container.dart';

class MessageBuilderForStream extends StatefulWidget {
  final String myIdUser;
  final Group group;

  const MessageBuilderForStream(
      {required this.myIdUser, required this.group, Key? key})
      : super(key: key);

  @override
  State<MessageBuilderForStream> createState() => _MessageBuilderForStream();
}

class _MessageBuilderForStream extends State<MessageBuilderForStream> {
  late Stream<List<Message>> _myStream;

  @override
  void initState() {
    super.initState();
    _myStream = FirebaseApi.loadStreamChat(widget.group.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: _myStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Text('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data;

              return messages!.isEmpty
                  ? Container()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageContainer(
                          message: message,
                          lastMessageUserId: (index == 0)
                              ? message.id_user
                              : messages[index - 1].id_user,
                          isMe: (widget.myIdUser == message.id_user),
                          isStream: true,
                        );
                      },
                    );
            }
        }
      },
    );
  }


}
