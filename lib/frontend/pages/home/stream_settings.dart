import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/models/category.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/back_button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

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
  late double _distanceToField;
  final TextfieldTagsController _controllerTags = TextfieldTagsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

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
                    const CustomBackButton(
                      color: Colors.black,
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

                    ///
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 4.r),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Material(
                              elevation: 4.0,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final dynamic option =
                                        options.elementAt(index);
                                    return TextButton(
                                      onPressed: () {
                                        onSelected(option);
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text(
                                            '#$option',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 74, 137, 92),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        List<String> list = [];
                        Provider.of<CategoryController>(context, listen: false)
                            .categories
                            .where((Hashtag option) {
                          return option.name
                              .contains(textEditingValue.text.toLowerCase());
                        }).forEach((item) {
                          list.add(item.name);
                        });
                        return list;
                      },
                      onSelected: (String selectedTag) {
                        _controllerTags.addTag = selectedTag;
                      },
                      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                        return TextFieldTags(
                          textEditingController: ttec,
                          focusNode: tfn,
                          textfieldTagsController: _controllerTags,
                          textSeparators: const [' ', ','],
                          letterCase: LetterCase.normal,
                          validator: (String tag) {
                            if (_controllerTags.getTags!.contains(tag)) {
                              return 'you already entered that';
                            }
                            return null;
                          },
                          inputfieldBuilder: (context, tec, fn, error,
                              onChanged, onSubmitted) {
                            return ((context, sc, tags, onTagDelete) {
                              return TextField(
                                controller: tec,
                                focusNode: fn,
                                cursorColor: accentColorTwo,
                                style: TextStyle(
                                  fontSize: kMainTxtSize,
                                  letterSpacing: 0.0,
                                  fontFamily: "SFProDisplayMedium",
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                        color: lighterGreyColor, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                        color: lighterGreyColor, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                        color: lighterGreyColor, width: 2.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                        color: lighterGreyColor, width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: BorderSide(
                                        color: lighterGreyColor, width: 2.0),
                                  ),
                                  filled: true,
                                  fillColor: lighterGreyColor,
                                  contentPadding: EdgeInsets.all(12.r),
                                  isCollapsed: true,
                                  helperText: 'Enter language...',
                                  helperStyle: TextStyle(
                                    color: accentColor,
                                    fontSize: kMainTxtSize,
                                    fontFamily: "SFProDisplayMedium",
                                  ),
                                  hintText: _controllerTags.hasTags
                                      ? ''
                                      : "Enter tag...",
                                  hintStyle: TextStyle(
                                    fontSize: kMainTxtSize,
                                    letterSpacing: 0.0,
                                    fontFamily: "SFProDisplayMedium",
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  errorText: error,
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: _distanceToField * 0.74),
                                  prefixIcon: tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: sc,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.r),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    accentColor,
                                                    accentColorTwo,
                                                  ],
                                                ),
                                              ),
                                              margin:
                                                  EdgeInsets.only(right: 10.r),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.r,
                                                  vertical: 4.r),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      '#$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4.r,
                                                  ),
                                                  GestureDetector(
                                                    child: Icon(
                                                      Icons.cancel,
                                                      size: 14.r,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              233,
                                                              233,
                                                              233),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        )
                                      : null,
                                ),
                                onChanged: onChanged,
                                onSubmitted: onSubmitted,
                              );
                            });
                          },
                        );
                      },
                    ),

                    ///
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
                      color1: accentColor,
                      color2: accentColorTwo,
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
