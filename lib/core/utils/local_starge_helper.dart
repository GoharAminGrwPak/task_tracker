import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class LocalStorageHelper{
  LocalStorageHelper._();
  static final GetStorage _box = GetStorage();
  static dynamic getData({required String key}){
    return _box.read(key);
  }
  static bool hasData({required String key}){
    return _box.hasData(key);
  }
  static void removeData({required String key})async{
    _box.remove(key);
  }static Future<bool> init()async{
     return GetStorage.init();
  }

  static void saveData({required String key,required dynamic value})async{
    var encodedData = await jsonEncode(value);
    if(value is bool ||value is num || value is String){
      _box.write(key, value);
    }else {
      _box.write(key, encodedData);
    }
    _box.save();
  }
}