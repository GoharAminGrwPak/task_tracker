import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_tracker/bootstrap/main_app.dart';
import 'package:task_tracker/core/network/dio_cache_interceptor_helper.dart';
import 'package:task_tracker/core/utils/local_starge_helper.dart';
import 'package:task_tracker/firebase_options.dart';

import 'injection_container.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DioCacheInterceptorHelper.init();
  await initDependencies();
  await dotenv.load(fileName: ".env");
  await LocalStorageHelper.init().then((value){
    LocalStorageHelper.saveData(key:'accessToken' , value: '${dotenv.env['API_TOKEN']}');
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
