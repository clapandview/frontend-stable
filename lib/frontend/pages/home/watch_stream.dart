import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchStreamPage extends StatefulWidget {
  const WatchStreamPage({
    Key? key,
    required this.id,
    required this.isPublisher,
  }) : super(key: key);

  final String id;
  final bool isPublisher;

  @override
  State<WatchStreamPage> createState() => _WatchStreamPageState();
}

class _WatchStreamPageState extends State<WatchStreamPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkerGreyColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Stream Here
            (widget.isPublisher)
                ? Positioned(
                    top: kMainSpacing,
                    right: kMainSpacing,
                    child: const SizedBox(),
                  )
                : Positioned(
                    top: kMainSpacing,
                    right: kMainSpacing,
                    child: CustomCircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: ClapAndViewIcons.multiply,
                    ),
                  ),
            (widget.isPublisher)
                ? Positioned(
                    bottom: kMainSpacing,
                    left: kMainSpacing,
                    right: kMainSpacing,
                    child: CustomButton(
                      onTap: () async {
                        setState(() {
                          loading = !loading;
                        });

                        Provider.of<BroadcastController>(context, listen: false)
                            .currentStream
                            .status = 3;

                        await Provider.of<BroadcastController>(context,
                                listen: false)
                            .updateStatus(Provider.of<BroadcastController>(
                                    context,
                                    listen: false)
                                .currentStream);
                        setState(() {
                          loading = !loading;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      text: AppLocalizations.of(context)!
                          .translate('finish_broadcast'),
                      height: kToolbarHeight / 1.2,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15.0,
                      loading: loading,
                    ),
                  )
                : Positioned(
                    bottom: kMainSpacing,
                    left: kMainSpacing,
                    right: kMainSpacing,
                    child: const SizedBox(),
                  ),
          ],
        ),
      ),
    );
  }
}
