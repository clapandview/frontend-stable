import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:clap_and_view/client/api/firebase_api.dart';
import 'package:clap_and_view/client/controllers/session_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/group.dart';
import 'package:clap_and_view/client/models/meta.dart';
import 'package:clap_and_view/client/models/session.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:clap_and_view/frontend/widgets/chat/chat_new_message.dart';
import 'package:clap_and_view/frontend/widgets/chat/message_builder_for_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WatchStreamPage extends StatefulWidget {
  const WatchStreamPage({
    Key? key,
    required this.streamId,
    required this.userId,
  }) : super(key: key);

  final String streamId;
  final String userId;

  @override
  State<WatchStreamPage> createState() => _WatchStreamPageState();
}

class _WatchStreamPageState extends State<WatchStreamPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inStream = false;
  var uuid = const Uuid();
  var resId = "";
  Group? group;

  @override
  initState() {
    super.initState();
    resId = uuid.v4();
    initRenderers();
    initGroup();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  initGroup() async {
    group = await FirebaseApi.getGroupByIdStream2(widget.streamId);
    setState(() {});
  }

  @override
  deactivate() {
    super.deactivate();
    if (AntMediaFlutter.anthelper != null) AntMediaFlutter.anthelper?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void _connect() async {
    AntMediaFlutter.connect(
      //host
      serverUrl,
      //streamID
      widget.streamId,
      //roomID
      '',
      AntMediaType.Play,
      false,
      false,
      //onStateChange
      (HelperState state) {
        switch (state) {
          case HelperState.CallStateNew:
            setState(() {
              _inStream = true;
            });
            break;
          case HelperState.CallStateBye:
            setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inStream = false;
              Navigator.pop(context);
            });
            break;
          case HelperState.ConnectionClosed:
          case HelperState.ConnectionError:
          case HelperState.ConnectionOpen:
            break;
        }
      },

      //onLocalStream
      ((stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      }),

      //onAddRemoteStream
      ((stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      }),

      // onDataChannel
      (datachannel) {
        if (kDebugMode) {
          print(datachannel.id);
          print(datachannel.state);
        }
      },

      // onDataChannelMessage
      (channel, message, isReceived) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${isReceived ? "Received:" : "Sent:"} ${message.text}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ));
      },

      // onupdateConferencePerson
      (stream) {},

      //onRemoveRemoteStream
      ((stream) {
        setState(() {
          _remoteRenderer.srcObject = null;
        });
      }),
    );
  }

  _finish() {
    AntMediaFlutter.anthelper?.bye();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: darkGreyColor,
      ),
      child: Scaffold(
        backgroundColor: darkerGreyColor,
        body: SafeArea(
            child: (group == null)
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(color: darkGreyColor),
                          child: RTCVideoView(_remoteRenderer),
                        ),
                      ),
                      Positioned.fill(child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      )),
                      Positioned(
                        top: kMainSpacing,
                        right: kMainSpacing,
                        child: CustomCircleButton(
                          onTap: () {
                            Meta meta = Meta(
                                status: 1,
                                user_id: widget.userId,
                                stream_id: widget.streamId);
                            Session session = Session(
                                id: '',
                                ts: DateTime.now(),
                                metadata: meta,
                                revenue: 0.0);
                            Provider.of<SessionController>(context,
                                    listen: false)
                                .createOne(session);
                            if (_inStream) {
                              _finish();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: ClapAndViewIcons.multiply,
                          color: Colors.black.withOpacity(0.75),
                          colorIcon: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: kMainSpacing / 2,
                        bottom: kMainSpacing / 2,
                        height: 1.sh / 2.5,
                        width: 1.sw / 1.5,
                        child: Column(
                          children: [
                            Expanded(
                              child: MessageBuilderForStream(
                                myIdUser: (GetStorage().read('isLoggedIn'))
                                    ? Provider.of<UserController>(context,
                                            listen: false)
                                        .currentUser
                                        .id
                                    : resId,
                                group: group!,
                              ),
                            ),
                            ChatNewMessage(
                              idUser: (GetStorage().read('isLoggedIn'))
                                  ? Provider.of<UserController>(context,
                                          listen: false)
                                      .currentUser
                                      .id
                                  : resId,
                              idGroup: group!.id,
                              isStream: true,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
