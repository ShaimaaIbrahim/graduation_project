import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/pages/splash_screen/splash_page.dart';
import 'package:untitled2/provider/ChatProvider.dart';
import 'package:untitled2/provider/ColleguesProvider.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/provider/DoctorProvider.dart';
import 'package:untitled2/provider/EditProfileProvider.dart';
import 'package:untitled2/provider/HistoryProvider.dart';
import 'package:untitled2/provider/NotificationProvider.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/provider/StudentMainScreenProvider.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'package:untitled2/utilities/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => DoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => StudentProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => PrecenceProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => DoctorMainScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => StudentMainScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => EditProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ColleguesProvider(),
        )
      ],
      child: Listener(
        onPointerDown: (_) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          initialRoute: SplashScreen.routeName,
          routes: routes,
        ),
      ),
    );
  }
}
