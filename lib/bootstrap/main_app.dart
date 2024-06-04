import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/localization/translation_provider.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/navigation/route_generator.dart';
import 'package:task_tracker/core/common/theme/app_theme.dart';
import 'package:task_tracker/core/common/theme/theme_controller.dart';
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return AnnotatedRegion<SystemUiOverlayStyle>(
     value: SystemUiOverlayStyle.dark,
     child: GetMaterialApp(
        title: '${AppString.app_name}',
        theme: lightTheme,
        darkTheme: darkTheme,
       themeMode: AppDependency<ThemeController>().
       isDarkMode.value==true?ThemeMode.dark:ThemeMode.light,
         translations: TranslationHelper(),
         navigatorObservers: [
           if(!kIsWeb)FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
       ],
       // fallbackLocale: BaseHelper.isArabic==false?Locale('en', 'US'):Locale('ar', 'SA'),
       localizationsDelegates: [
         GlobalMaterialLocalizations.delegate,
         GlobalWidgetsLocalizations.delegate,
         GlobalCupertinoLocalizations.delegate,
       ],
       supportedLocales: <Locale>[
         Locale('en', 'US'),
         Locale('ar', 'SA'),
         Locale('tr', 'TR'),
         Locale('ur', 'PK'),
       ],
       debugShowCheckedModeBanner: false,
         initialRoute: AppRoutes.dashBoardRoute,
         onGenerateRoute: RouteGenerator.generateRoute
      ),
   );
  }
}
