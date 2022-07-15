import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/pages/home/stream_settings.dart';
import 'package:clap_and_view/frontend/pages/home/watch_stream.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublishStreamPage extends StatefulWidget {
  const PublishStreamPage({Key? key}) : super(key: key);

  @override
  State<PublishStreamPage> createState() => _PublishStreamPageState();
}

class _PublishStreamPageState extends State<PublishStreamPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stream Here
        Positioned(
          top: kMainSpacing,
          right: kMainSpacing,
          child: Row(
            children: [
              CustomCircleButton(
                onTap: () {},
                icon: ClapAndViewIcons.camera_change,
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

              Provider.of<BroadcastController>(context, listen: false)
                  .currentStream
                  .status = 2;

              await Provider.of<BroadcastController>(context, listen: false)
                  .updateStatus(
                      Provider.of<BroadcastController>(context, listen: false)
                          .currentStream);
              setState(() {
                loading = !loading;
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                SlideRoute(
                  page: WatchStreamPage(
                    // ignore: use_build_context_synchronously
                    id: Provider.of<BroadcastController>(context, listen: false)
                        .currentStream
                        .id,
                    isPublisher: true,
                  ),
                ),
              );
            },
            text: AppLocalizations.of(context)!.translate('start_broadcast'),
            height: kToolbarHeight / 1.2,
            width: MediaQuery.of(context).size.width,
            borderRadius: 15.0,
            loading: loading,
          ),
        ),
      ],
    );
  }
}
