import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'api_request_http.dart';

class DioCacheInterceptorHelper{
// Global options
  static final options =  CacheOptions(
    store: MemCacheStore(maxSize: 10485760,maxEntrySize: 1048576),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401,403,422],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );
  static CacheOptions? option;
  static getCacheInterceptor() {
    debugPrint('DioCacheInterceptor');
    if(kIsWeb){
      return InterceptorsWrapper(onResponse: ApiRequestHttp.responseInterceptor);
    }
      return DioCacheInterceptor(options: option!);
  }
  static init()async{
    if(kIsWeb){
      return;
    }
    final directory = (Platform.isIOS)?(await getApplicationDocumentsDirectory()).path:(await getTemporaryDirectory()).path;
    var cacheStore = HiveCacheStore(
      directory,
      hiveBoxName: "api_cache",
    );
    var customCacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refresh,
      priority: CachePriority.normal,
      maxStale: const Duration(days: 1),
      hitCacheOnErrorExcept: [401,403,422],
      keyBuilder: (request) {
        return request.uri.toString();
      },
      allowPostMethod: false,
    );
    option=customCacheOptions;
    return customCacheOptions;
  }
}