import 'package:flutter/material.dart';
import 'package:task_tracker/features/dashboard/presentation/pages/create_project_step1_page.dart';
import 'package:task_tracker/features/dashboard/presentation/pages/create_project_step2_page.dart';
import 'package:task_tracker/features/dashboard/presentation/pages/create_project_step3_page.dart';
import 'package:task_tracker/features/dashboard/presentation/pages/dashboard_page.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.dashBoardRoute:
        return MaterialPageRoute(builder: (_) => DashboardPage());
        case AppRoutes.newTaskStep1:
        return MaterialPageRoute(builder: (_) => CreateProjectTypePage());
        case AppRoutes.newTaskStep2:
        return MaterialPageRoute(builder: (_) => CreateProjectPage());
        case AppRoutes.newTaskStep3:
        return MaterialPageRoute(builder: (_) => CreateProjectSuccessPage());
      default:
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

}