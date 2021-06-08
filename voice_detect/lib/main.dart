import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_detect/constants/constants.dart';
import 'package:voice_detect/screens/clientHome.dart';
import 'package:voice_detect/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:voice_detect/screens/masterHome.dart';
import 'package:voice_detect/screens/selectClient.dart';
import 'package:voice_detect/screens/selectUserType.dart';
import 'package:voice_detect/screens/settingScreen.dart';
import 'package:voice_detect/screens/splash.dart';
import 'package:voice_detect/screens/verifyOtp.dart';
import 'package:voice_detect/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          supportedLocales: locales,
          localizationsDelegates: [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: 'Voice Detect',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: auth.isAuth
              ? auth.usertype == 'CLIENT'
                  ? ClientHomeScreen()
                  : MasterHomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(context),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : snapshot.data == false
                              ? SelectUser()
                              : auth.usertype == 'CLIENT'
                                  ? ClientHomeScreen()
                                  : MasterHomeScreen(),
                ),
          routes: {
            Login.routeName: (ctx) => Login(),
            VerifyOTP.routeName: (ctx) => VerifyOTP(),
            ClientHomeScreen.routeName: (ctx) => ClientHomeScreen(),
            SelectUser.routeName: (ctx) => SelectUser(),
            MasterHomeScreen.routeName: (ctx) => MasterHomeScreen(),
            SettingScreen.routeName: (ctx) => SettingScreen(),
            SelectClient.routeName: (ctx) => SelectClient(),
          },
        ),
      ),
    );
  }
}
