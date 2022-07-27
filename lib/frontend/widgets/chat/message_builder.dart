import 'package:clap_and_view/client/api/firebase_api.dart';
import 'package:clap_and_view/client/models/group.dart';
import 'package:clap_and_view/client/models/message.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:flutter/material.dart';
import 'message_container.dart';

class MessageBuilder extends StatefulWidget {
  final String myIdUser;
  final User user;
  final Group group;

  const MessageBuilder(
      {required this.myIdUser,
      required this.user,
      required this.group,
      Key? key})
      : super(key: key);

  @override
  State<MessageBuilder> createState() => _MessageBuilder();
}

class _MessageBuilder extends State<MessageBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.loadChat(widget.group.id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? Center(
                        child: Text(
                        AppLocalizations.of(context)!
                            .translate('type_first_message'),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: lighterGreyColor,
                            fontSize: kMainTxtSize * 2,
                            fontFamily: "SFProDisplayRegular",
                            overflow: TextOverflow.ellipsis),
                      ))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageContainer(
                              message: message,
                              lastMessageUserId: (index == 0)
                                  ? message.id_user
                                  : messages[index - 1].id_user,
                              profilePic: widget.user.profile_pic,
                              isMe: (widget.myIdUser == message.id_user),
                            isStream: false,);
                        },
                      );
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

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      FirebaseApi.loadChat(widget.group.id);
    }
  }
}
