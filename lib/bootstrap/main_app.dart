import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/navigation/route_generator.dart';
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return AnnotatedRegion<SystemUiOverlayStyle>(
     value: SystemUiOverlayStyle.dark,
     child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.mainColor),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.mainColor),
          useMaterial3: true,
        ),
       navigatorObservers: [
         // if(!kIsWeb)FirebaseAnalyticsObserver(analytics: AnalyticsHelper.analytics),
       ],
       // fallbackLocale: BaseHelper.isArabic==false?Locale('en', 'US'):Locale('ar', 'SA'),
       // localizationsDelegates: [
       //   GlobalMaterialLocalizations.delegate,
       //   GlobalWidgetsLocalizations.delegate,
       //   GlobalCupertinoLocalizations.delegate,
       // ],
       // supportedLocales: <Locale>[
       //   Locale('en', 'US'),
       //   Locale('ar',"SA")
       // ],
       debugShowCheckedModeBanner: false,
         initialRoute: AppRoutes.dashBoardRoute,
         onGenerateRoute: RouteGenerator.generateRoute
      ),
   );
  }
}
