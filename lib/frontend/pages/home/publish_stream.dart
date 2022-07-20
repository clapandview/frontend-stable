// ignore_for_file: use_build_context_synchronously
import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/pages/home/stream_settings.dart';
import 'package:clap_and_view/frontend/pages/home/watch_stream.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';

class PublishStreamPage extends StatefulWidget {
  const PublishStreamPage({Key? key}) : super(key: key);

  @override
  State<PublishStreamPage> createState() => _PublishStreamPageState();
}

class _PublishStreamPageState extends State<PublishStreamPage> {
  bool loading = false;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isStreaming = false;
  bool _micOn = true;

  @override
  initState() {
    super.initState();
    initRenderers();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await Provider.of<BroadcastController>(context, listen: false).createOne(
      StreamModel(
        id: "",
        user_id:
            Provider.of<UserController>(context, listen: false).currentUser.id,
        title: "",
        author_name: Provider.of<UserController>(context, listen: false)
            .currentUser
            .name,
        author_username: Provider.of<UserController>(context, listen: false)
            .currentUser
            .username,
        hashtag_list: [],
        description: "",
        link: "",
        thumbnail: "basic",
        count: 0,
        status: 1,
        smart_score: 0.0,
        restricted_phone_list: [],
        restricted_country_list: [],
      ),
    );
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
      Provider.of<BroadcastController>(context, listen: false).currentStream.id,

      //roomID
      '',

      AntMediaType.Publish,

      false,

      false,

      //onStateChange
      (HelperState state) {
        switch (state) {
          case HelperState.CallStateNew:
            setState(() {
              _isStreaming = true;
            });
            break;
          case HelperState.CallStateBye:
            setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _isStreaming = false;
              //Navigator.pop(context);
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
      (streams) {},

      //onRemoveRemoteStream
      ((stream) {
        setState(() {
          _remoteRenderer.srcObject = null;
        });
      }),
    );
  }

  _finish() {
    if (AntMediaFlutter.anthelper != null) {
      AntMediaFlutter.anthelper?.bye();
    }
  }

  _switchCamera() {
    AntMediaFlutter.anthelper?.switchCamera();
  }

  _muteMic(bool state) {
    if (_micOn) {
      setState(() {
        AntMediaFlutter.anthelper?.muteMic(true);
        _micOn = false;
      });
    } else {
      setState(() {
        AntMediaFlutter.anthelper?.muteMic(false);
        _micOn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(_remoteRenderer),
              ),
            ),
          ),
          Positioned(
            top: kMainSpacing,
            right: kMainSpacing,
            child: Row(
              children: [
                (_isStreaming)
                    ? Row(
                        children: [
                          CustomCircleButton(
                            onTap: () => _muteMic(_micOn),
                            icon: _micOn
                                ? ClapAndViewIcons.camera_change
                                : ClapAndViewIcons.camera_change,
                            color: Colors.black.withOpacity(0.75),
                            colorIcon: Colors.white,
                          ),
                          SizedBox(
                            width: kMainSpacing,
                          ),
                          CustomCircleButton(
                            onTap: () => _switchCamera(),
                            icon: ClapAndViewIcons.camera_change,
                            color: Colors.black.withOpacity(0.75),
                            colorIcon: Colors.white,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: kMainSpacing,
                        width: kMainSpacing,
                      ),
                SizedBox(
                  width: kMainSpacing,
                ),
                CustomCircleButton(
                  onTap: () => Navigator.of(context).push(
                    SlideRoute(
                      page: const StreamSettings(),
                    ),
                  ),
                  icon: ClapAndViewIcons.setting,
                  color: Colors.black.withOpacity(0.75),
                  colorIcon: Colors.white,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: kMainSpacing,
            left: kMainSpacing,
            right: kMainSpacing,
            child: CustomButton(
              onTap: () async {
                setState(() {
                  loading = !loading;
                });

                if (_isStreaming) {
                  Provider.of<BroadcastController>(context, listen: false)
                      .currentStream
                      .status = 3;
                  _finish();
                } else {
                  Provider.of<BroadcastController>(context, listen: false)
                      .currentStream
                      .status = 2;
                  _connect();
                }

                await Provider.of<BroadcastController>(context, listen: false)
                    .updateStatus(
                        Provider.of<BroadcastController>(context, listen: false)
                            .currentStream);
                setState(() {
                  loading = !loading;
                });
                Navigator.of(context).push(
                  SlideRoute(
                    page: WatchStreamPage(
                      id: Provider.of<BroadcastController>(context,
                              listen: false)
                          .currentStream
                          .id,
                    ),
                  ),
                );
              },
              text: AppLocalizations.of(context)!.translate('start_broadcast'),
              height: kToolbarHeight / 1.2,
              width: MediaQuery.of(context).size.width,
              borderRadius: 15.r,
              color1: accentColor,
              color2: accentColorTwo,
              loading: loading,
            ),
          ),
        ],
      );
    });
  }
}
