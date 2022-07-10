import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/common_ui_elements/header.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ImagePicker _picker = ImagePicker();
  bool loading = false;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNickname = TextEditingController();
  final TextEditingController _controllerBio = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();

  @override
  void initState() {
    _controllerName.text =
        Provider.of<UserController>(context, listen: false).currentUser.name;
    _controllerNickname.text =
        Provider.of<UserController>(context, listen: false)
            .currentUser
            .username;
    _controllerBio.text = Provider.of<UserController>(context, listen: false)
        .currentUser
        .description;
    _controllerLink.text =
        Provider.of<UserController>(context, listen: false).currentUser.link;
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerNickname.dispose();
    _controllerBio.dispose();
    _controllerLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              title: 'settings',
              subtitle: 'settings_desc',
              isSettings: true,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${baseUrl}user/DownloadProfilePic/${Provider.of<UserController>(context, listen: true).currentUser.profile_pic}",
                    width: kToolbarHeight * 1.8,
                    height: kToolbarHeight * 1.8,
                    fit: BoxFit.cover,
                    httpHeaders: {
                      'authorization': 'Bearer ${GetStorage().read('token')}'
                    },
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () => startImagePicker(),
                    text: AppLocalizations.of(context)!.translate('change'),
                    height: kToolbarHeight / 1.2,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 15.0,
                    loading: false,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: _controllerName,
              keyboardType: TextInputType.name,
              text: AppLocalizations.of(context)!.translate('name'),
              cap: TextCapitalization.words,
              maxLines: 1,
              minLines: 1,
              maxLength: 100,
              borderRadius: 15.0,
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
              height: 20.r,
            ),
            CustomTextField(
              controller: _controllerNickname,
              keyboardType: TextInputType.name,
              text: AppLocalizations.of(context)!.translate('nickname'),
              cap: TextCapitalization.none,
              maxLines: 1,
              minLines: 1,
              maxLength: 100,
              borderRadius: 15.0,
              colorTextMain: Colors.black,
              colorTextHover: Colors.black.withOpacity(0.5),
              colorMain: lighterGreyColor,
              onChanged: (text) {},
              list: [
                LengthLimitingTextInputFormatter(100),
                LowerCaseTextFormatter(),
                FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
              ],
              letterSpacing: 0.0,
            ),
            SizedBox(
              height: 20.r,
            ),
            CustomTextField(
              controller: _controllerLink,
              keyboardType: TextInputType.url,
              text: AppLocalizations.of(context)!.translate('link'),
              cap: TextCapitalization.none,
              maxLines: 1,
              minLines: 1,
              maxLength: 300,
              borderRadius: 15.0,
              colorTextMain: Colors.black,
              colorTextHover: Colors.black.withOpacity(0.5),
              colorMain: lighterGreyColor,
              onChanged: (text) {},
              list: [
                LengthLimitingTextInputFormatter(300),
              ],
              letterSpacing: 0.0,
            ),
            SizedBox(
              height: 20.r,
            ),
            CustomTextField(
              controller: _controllerBio,
              keyboardType: TextInputType.text,
              text: AppLocalizations.of(context)!.translate('bio'),
              cap: TextCapitalization.sentences,
              maxLines: 0,
              minLines: 2,
              maxLength: 500,
              borderRadius: 15.0,
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
              height: 20.r,
            ),
            CustomButton(
              onTap: () async {
                setState(() {
                  loading = !loading;
                });

                Provider.of<UserController>(context, listen: false)
                    .updateName(_controllerName.text);
                Provider.of<UserController>(context, listen: false)
                    .updateNickname(_controllerNickname.text);
                Provider.of<UserController>(context, listen: false)
                    .updateBio(_controllerBio.text);
                Provider.of<UserController>(context, listen: false)
                    .updateLink(_controllerLink.text);

                await Provider.of<UserController>(context, listen: false)
                    .updateUser(
                        Provider.of<UserController>(context, listen: false)
                            .currentUser);
                setState(() {
                  loading = !loading;
                });
              },
              text: AppLocalizations.of(context)!.translate('save'),
              height: kToolbarHeight / 1.2,
              width: MediaQuery.of(context).size.width,
              borderRadius: 15.0,
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }

  void startImagePicker() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // ignore: use_build_context_synchronously
      await Provider.of<UserController>(context, listen: false)
          .startUploadImg(image);
    }
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
