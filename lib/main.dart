import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_cap/Services/settings_service.dart';
import 'package:smart_cap/Services/translation_service.dart';
import 'package:smart_cap/Utilities/RoutesManagement/pages.dart';
import 'package:smart_cap/dataprovider.dart';
import 'package:smart_cap/globalvariabels.dart';
import 'package:smart_cap/screens/LogIn/login_binding.dart';
import 'package:smart_cap/screens/LogIn/loginpage.dart';
import 'package:smart_cap/screens/StartPage.dart';
import 'package:smart_cap/screens/UnRegistration.dart';
import 'package:smart_cap/screens/mainpage.dart';
import 'package:smart_cap/screens/registration.dart';
import 'package:smart_cap/screens/splash/splash_binding.dart';
import 'package:smart_cap/screens/splash/splash_view.dart';
import 'package:smart_cap/screens/vehicleinfo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await Get.putAsync(() => SettingsService().init());
  LogInBinding().dependencies();
  SplashBinding().dependencies();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/undraw_bug_fixing_oc-7-a.svg'),
            const SizedBox(height: 30),
            Text(details.exception.toString()),
            const SizedBox(height: 30),
            Text(details.stackFilter.toString())
          ],
        ),
      ),
    );
  };

  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        translations: TranslationService(),
        locale: SettingsService().getLocale(),
        fallbackLocale: TranslationService.fallbackLocale,
        theme: Get.find<SettingsService>().getLightTheme(),
        getPages: AppPages.routes,
        home: currentFirebaseUser == null
            ? const LoginPage()
            : const SplashView(),
        routes: {
          MainPage.id: (context) => const MainPage(),
          RegistrationPage.id: (context) => const RegistrationPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
          LoginPage.id: (context) => const LoginPage(),
          StartPage.id: (context) => StartPage(),
          UnRegistration.id: (context) => const UnRegistration(),
        },
      ),
    );
  }
}
