import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_tracker/bootstrap/main_app.dart';
import 'package:task_tracker/core/network/dio_cache_interceptor_helper.dart';
import 'package:task_tracker/core/utils/local_starge_helper.dart';

import 'injection_container.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageHelper.init().then((value){

  });
  await DioCacheInterceptorHelper.init();
  await initDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MainApp());
}
