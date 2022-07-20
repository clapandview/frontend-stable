import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

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
    final phone = GetStorage().read('phone');
    bool isLoggedIn = false;

    if (phone != null) {
      await Provider.of<UserController>(context, listen: false).auth(
        User(
          id: "",
          phone: phone,
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
          balance: 0,
          email: "",
        ),
      );

      isLoggedIn = true;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        FadeRoute(
          page: HomePage(
            isLoggedIn: isLoggedIn,
          ),
        ),
      );
    });
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
