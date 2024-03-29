import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/session_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'frontend/logic/app_localizations.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();

  GetStorage().write('isLoggedIn', false);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryController>(
          create: (context) => CategoryController(),
        ),
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider<BroadcastController>(
          create: (context) => BroadcastController(),
        ),
        ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Clap And View',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(primarySwatch: Colors.grey),
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomePage(),
        );
      },
    );
  }
}
