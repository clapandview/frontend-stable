import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/message.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';

import '../../../client/api/firebase_api.dart';

class ChatNewMessage extends StatefulWidget {
  final String idUser;
  final String idGroup;
  final bool isStream;

  const ChatNewMessage({
    required this.idUser,
    required this.idGroup,
    required this.isStream,
    Key? key,
  }) : super(key: key);

  @override
  _ChatNewMessageState createState() => _ChatNewMessageState();
}

class _ChatNewMessageState extends State<ChatNewMessage> {
  final _controller = TextEditingController();
  late String idGroup;
  Message message =
      Message(id_user: "", message_text: "", username: "", sent_at: null);

  void sendMessage() async {
    if (message.message_text != "") {
      message.sent_at = message.sent_at = DateTime.now();
      await FirebaseApi.uploadMessage(widget.idGroup, message);
      message.message_text = "";
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) => (widget.isStream)
      ? Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.all(Radius.circular(20.w))),
          padding: EdgeInsets.all(1.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  text: AppLocalizations.of(context)!
                      .translate("type_new_message"),
                  cap: TextCapitalization.sentences,
                  maxLines: 6,
                  minLines: 1,
                  maxLength: 120,
                  borderRadius: 15.0,
                  colorTextMain: Colors.white,
                  colorTextHover: lightGreyColor,
                  colorMain: Colors.transparent,
                  enableSuggestions: true,
                  list: [
                    LengthLimitingTextInputFormatter(120),
                  ],
                  letterSpacing: 0.8,
                  onChanged: (value) => setState(() {
                    message.id_user =
                        Provider.of<UserController>(context, listen: false)
                            .currentUser
                            .id;
                    message.message_text = value;
                    message.username =
                        Provider.of<UserController>(context, listen: false)
                            .currentUser
                            .username;
                  }),
                  onSubmitted: (value) => setState(() {
                    message.message_text = "";
                  }),
                  cursorColor: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  color: Colors.transparent,
                  height: kToolbarHeight / 1.2,
                  width: kToolbarHeight / 1.2,
                  child: const Center(
                    child: Icon(
                      ClapAndViewIcons.message_45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      : Container(
          color: darkerGreyColor,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
          child: Row(
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  text: AppLocalizations.of(context)!
                      .translate("type_new_message"),
                  cap: TextCapitalization.sentences,
                  maxLines: 7,
                  minLines: 1,
                  maxLength: 2000,
                  borderRadius: 15.0,
                  colorTextMain: Colors.white,
                  colorTextHover: lightGreyColor,
                  colorMain: darkGreyColor,
                  enableSuggestions: true,
                  list: [
                    LengthLimitingTextInputFormatter(2000),
                  ],
                  letterSpacing: 0.8,
                  onChanged: (value) => setState(() {
                    message.id_user =
                        Provider.of<UserController>(context, listen: false)
                            .currentUser
                            .id;
                    message.message_text = value;
                    message.username =
                        Provider.of<UserController>(context, listen: false)
                            .currentUser
                            .username;
                  }),
                  onSubmitted: (value) => setState(() {
                    message.message_text = "";
                  }),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  color: Colors.transparent,
                  height: kToolbarHeight / 1.2,
                  width: kToolbarHeight / 1.2,
                  child: const Center(
                    child: Icon(
                      ClapAndViewIcons.message_45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
}
