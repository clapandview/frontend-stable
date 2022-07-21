import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/common_ui_elements/header.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late DateTime date;
  final ImagePicker _picker = ImagePicker();
  bool loading = false;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNickname = TextEditingController();
  final TextEditingController _controllerBio = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();

  @override
  void initState() {
    date = DateTime(
        DateTime.now().year -
            Provider.of<UserController>(context, listen: false).currentUser.age,
        DateTime.now().month,
        DateTime.now().day);
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
        padding: EdgeInsets.all(kMainSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              title: 'settings',
              subtitle: 'here_you_can_change_personal_details',
              isSettings: true,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
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
                SizedBox(
                  width: kMainSpacing,
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () => startImagePicker(),
                    text: AppLocalizations.of(context)!.translate('change'),
                    height: kToolbarHeight / 1.2,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 15.r,
                    color1: accentColor,
                    color2: accentColorTwo,
                    loading: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kMainSpacing,
            ),
            CustomTextField(
              controller: _controllerName,
              keyboardType: TextInputType.name,
              text: AppLocalizations.of(context)!.translate('enter_your_name'),
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
              controller: _controllerNickname,
              keyboardType: TextInputType.name,
              text: AppLocalizations.of(context)!
                  .translate('enter_your_nickname'),
              cap: TextCapitalization.none,
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
                LowerCaseTextFormatter(),
                FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
              ],
              letterSpacing: 0.0,
            ),
            SizedBox(
              height: kMainSpacing,
            ),
            GestureDetector(
              onTap: () => (Platform.isIOS)
                  ? _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: date,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        maximumDate: date,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => date = newDate);
                        },
                      ),
                    )
                  : _selectDate(context),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: kToolbarHeight / 1.2,
                padding: EdgeInsets.only(
                  left: 15.r,
                  right: 15.r,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: lighterGreyColor,
                    width: 2.r,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.r),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      convertToAge().toString() +
                          AppLocalizations.of(context)!.translate('years_old'),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: kMainTxtSize,
                        fontFamily: "SFProDisplayMedium",
                      ),
                    ),
                    AutoSizeText(
                      '${date.month}-${date.day}-${date.year}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: kMainTxtSize,
                        fontFamily: "SFProDisplayMedium",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: kMainSpacing,
            ),
            CustomTextField(
              controller: _controllerLink,
              keyboardType: TextInputType.url,
              text: AppLocalizations.of(context)!.translate('link'),
              cap: TextCapitalization.none,
              maxLines: 1,
              minLines: 1,
              maxLength: 300,
              borderRadius: 15.r,
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
              height: kMainSpacing,
            ),
            CustomTextField(
              controller: _controllerBio,
              keyboardType: TextInputType.text,
              text: AppLocalizations.of(context)!.translate('description'),
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

                Provider.of<UserController>(context, listen: false)
                    .updateName(_controllerName.text);
                Provider.of<UserController>(context, listen: false)
                    .updateNickname(_controllerNickname.text);
                Provider.of<UserController>(context, listen: false)
                    .updateBio(_controllerBio.text);
                Provider.of<UserController>(context, listen: false)
                    .updateLink(_controllerLink.text);
                Provider.of<UserController>(context, listen: false)
                    .updateAge(convertToAge());

                await Provider.of<UserController>(context, listen: false)
                    .updateUser(
                        Provider.of<UserController>(context, listen: false)
                            .currentUser);
                setState(() {
                  loading = !loading;
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              text: AppLocalizations.of(context)!.translate('save'),
              height: kToolbarHeight / 1.2,
              width: MediaQuery.of(context).size.width,
              borderRadius: 15.r,
              color1: accentColor,
              color2: accentColorTwo,
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(
          DateTime.now().year - 150, DateTime.now().month, DateTime.now().day),
      lastDate: date,
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  int convertToAge() {
    LocalDate now = LocalDate.today();
    LocalDate bDate = LocalDate.dateTime(date);
    return now.periodSince(bDate).years;
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
