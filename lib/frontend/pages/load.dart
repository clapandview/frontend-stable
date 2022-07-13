import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    loadApp();
  }

  Future loadApp() async {
    //final phone = GetStorage().read('phone');

    await Provider.of<UserController>(context, listen: false).auth(
      User(
        id: "",
        phone: "77777777777",
        name: "",
        username: "",
        age: 0,
        following: [],
        following_count: 0,
        followers_count: 0,
        description: "",
        link: "",
        fav_hashtags: [],
        profile_pic: "",
        gender: "",
        gender_preference: [],
        datetime_registration: DateTime.now().toString(),
        balance: "",
        email: "",
      ),
    );

    // ignore: use_build_context_synchronously
    await Provider.of<BroadcastController>(context, listen: false).createOne(
      StreamModel(
        id: "",
        user_id:
            // ignore: use_build_context_synchronously
            Provider.of<UserController>(context, listen: false).currentUser.id,
        title: "",
        // ignore: use_build_context_synchronously
        author_name: Provider.of<UserController>(context, listen: false)
            .currentUser
            .name,
        // ignore: use_build_context_synchronously
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

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      FadeRoute(
        page: const HomePage(),
      ),
    );
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
        body: Container(),
      ),
    );
  }
}
