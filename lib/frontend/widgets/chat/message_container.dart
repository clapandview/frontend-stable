import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/models/message.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class MessageContainer extends StatelessWidget {
  final Message message;
  final String lastMessageUserId;
  final bool isMe;
  final bool isStream;
  final String? profilePic;

  const MessageContainer({
    Key? key,
    required this.message,
    required this.isStream,
    required this.lastMessageUserId,
    required this.isMe,
    this.profilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(kMainTxtSize);
    final borderRadius = BorderRadius.all(radius);
    // ignore: non_constant_identifier_names
    final double paddingSize = 2.w;
    final double sidePaddingSize = 5.w;

    return (isStream)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.5, 1],
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent
                        ],
                      ),
                      borderRadius: borderRadius,
                    ),
                    padding: EdgeInsets.all(3.w),
                    margin: EdgeInsets.only(
                        left: sidePaddingSize, right: sidePaddingSize),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5 -
                            kMainSpacing / 2),
                    child: buildMessage(
                        MediaQuery.of(context).textScaleFactor * 15,
                        "@${message.username}  ${message.message_text}"),
                  ),
                ],
              ),
              Container(
                height: (lastMessageUserId == message.id_user)
                    ? MediaQuery.of(context).size.width / 60
                    : MediaQuery.of(context).size.width / 20,
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (!isMe)
                    Container(
                      margin: EdgeInsets.only(left: paddingSize),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          width: kToolbarHeight / 2,
                          height: kToolbarHeight / 2,
                          fit: BoxFit.cover,
                          // ignore: unnecessary_brace_in_string_interps
                          imageUrl:
                              "${baseUrl}user/DownloadProfilePic/$profilePic",
                          httpHeaders: {
                            'authorization':
                                'Bearer ${GetStorage().read('token')}'
                          },
                        ),
                      ),
                    ),
                  Container(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 70),
                    margin:
                        EdgeInsets.only(left: paddingSize, right: paddingSize),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isMe ? accentColor : darkerGreyColor,
                          isMe ? accentColorTwo : darkerGreyColor,
                        ],
                      ),
                      borderRadius: isMe
                          ? borderRadius
                              .subtract(BorderRadius.only(bottomRight: radius))
                          : borderRadius
                              .subtract(BorderRadius.only(bottomLeft: radius)),
                    ),
                    child: buildMessage(
                        MediaQuery.of(context).textScaleFactor * 15,
                        message.message_text),
                  ),
                ],
              ),
              Container(
                height: (lastMessageUserId == message.id_user)
                    ? MediaQuery.of(context).size.width / 60
                    : MediaQuery.of(context).size.width / 20,
              ),
            ],
          );
  }

  Widget buildMessage(double fontSize, String messageText) {
    var autoSizeTextMessage = AutoSizeText(
      messageText,
      style: TextStyle(
          fontSize: fontSize,
          letterSpacing: 0.8,
          color: Colors.white,
          fontFamily: "SFProDisplayMedium"),
      textAlign: isMe ? TextAlign.end : TextAlign.start,
    );

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        autoSizeTextMessage,
      ],
    );
  }
}
