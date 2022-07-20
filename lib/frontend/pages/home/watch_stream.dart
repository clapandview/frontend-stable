import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WatchStreamPage extends StatefulWidget {
  const WatchStreamPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<WatchStreamPage> createState() => _WatchStreamPageState();
}

class _WatchStreamPageState extends State<WatchStreamPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inStream = false;

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
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
      widget.id,
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
    return Scaffold(
      backgroundColor: darkerGreyColor,
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return Stack(
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
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_remoteRenderer),
                ),
              ),
              Positioned(
                top: kMainSpacing,
                right: kMainSpacing,
                child: CustomCircleButton(
                  onTap: () {
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
            ],
          );
        }),
      ),
    );
  }
}
