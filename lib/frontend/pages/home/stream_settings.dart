import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StreamSettings extends StatefulWidget {
  const StreamSettings({Key? key}) : super(key: key);

  @override
  State<StreamSettings> createState() => _StreamSettingsState();
}

class _StreamSettingsState extends State<StreamSettings> {
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerTitle.text =
        Provider.of<BroadcastController>(context, listen: false)
            .currentStream
            .title;
    _controllerDescription.text =
        Provider.of<BroadcastController>(context, listen: false)
            .currentStream
            .description;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        color: Colors.transparent,
                        height: kToolbarHeight,
                        width: kToolbarHeight,
                        child: const Icon(
                          ClapAndViewIcons.angle_left_no_space,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      AppLocalizations.of(context)!
                          .translate('stream_settings'),
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: kMainTxtSize,
                        fontFamily: "SFProDisplaySemibold",
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight,
                      width: kToolbarHeight,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      EdgeInsets.only(left: kMainSpacing, right: kMainSpacing),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: kMainSpacing,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${baseUrl}stream/DownloadThumbnail/${Provider.of<BroadcastController>(context, listen: true).currentStream.thumbnail}",
                            width: kToolbarHeight * 1.8,
                            height: kToolbarHeight * 2.3,
                            fit: BoxFit.cover,
                            httpHeaders: {
                              'authorization':
                                  'Bearer ${GetStorage().read('token')}'
                            },
                          ),
                        ),
                        SizedBox(
                          width: kMainSpacing,
                        ),
                        Expanded(
                          child: CustomButton(
                            onTap: () => startImagePicker(),
                            text: AppLocalizations.of(context)!
                                .translate('change'),
                            height: kToolbarHeight / 1.2,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: 15.r,
                            loading: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: kMainSpacing,
                    ),
                    CustomTextField(
                      controller: _controllerTitle,
                      keyboardType: TextInputType.name,
                      text: AppLocalizations.of(context)!
                          .translate('stream_title'),
                      cap: TextCapitalization.words,
                      maxLines: 1,
                      minLines: 1,
                      maxLength: 100,
                      borderRadius: 15.r,
                      colorTextMain: Colors.black,
                      colorTextHover: Colors.black.withOpacity(0.5),
                      colorMain: lighterGreyColor,
                      onChanged: (text) {},
                      list: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      letterSpacing: 0.0,
                    ),
                    SizedBox(
                      height: kMainSpacing,
                    ),
                    CustomTextField(
                      controller: _controllerDescription,
                      keyboardType: TextInputType.text,
                      text: AppLocalizations.of(context)!
                          .translate('description'),
                      cap: TextCapitalization.sentences,
                      maxLines: 0,
                      minLines: 2,
                      maxLength: 500,
                      borderRadius: 15.r,
                      colorTextMain: Colors.black,
                      colorTextHover: Colors.black.withOpacity(0.5),
                      colorMain: lighterGreyColor,
                      onChanged: (text) {},
                      list: [
                        LengthLimitingTextInputFormatter(500),
                      ],
                      letterSpacing: 0.0,
                    ),
                    SizedBox(
                      height: kMainSpacing,
                    ),
                    CustomButton(
                      onTap: () async {
                        setState(() {
                          loading = !loading;
                        });

                        Provider.of<BroadcastController>(context, listen: false)
                            .updateTitle(_controllerTitle.text);
                        Provider.of<BroadcastController>(context, listen: false)
                            .updateDescription(_controllerDescription.text);

                        await Provider.of<BroadcastController>(context,
                                listen: false)
                            .updateStream(Provider.of<BroadcastController>(
                                    context,
                                    listen: false)
                                .currentStream);
                        setState(() {
                          loading = !loading;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      text: AppLocalizations.of(context)!.translate('save'),
                      height: kToolbarHeight / 1.2,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15.r,
                      loading: loading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startImagePicker() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // ignore: use_build_context_synchronously
      await Provider.of<BroadcastController>(context, listen: false)
          .startUploadImg(image);
    }
  }
}
