import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/core/utils/local_starge_helper.dart';

import 'api_error_code_handler.dart';
import 'dio_cache_interceptor_helper.dart';

class ApiRequestHttp{

  static  String BaseUrl='https://api.todoist.com/rest/';
  static Future getRequest({required String endpoint,String? query,required Function(dynamic) onData,required Function(dynamic) onError})async{
    try{
      String url="";
      if(query==null) {
        url="${BaseUrl}${endpoint}";
        print("${BaseUrl}${endpoint}");
      }else{
        url="${BaseUrl}${endpoint}${query}";

      }
      print(url);
      Map<String,String>? map;
      var data = LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }
      if(map==null){
        map={};
      }

      print("${url}");
      BaseOptions options=BaseOptions(headers: map,connectTimeout:const Duration(minutes: 1),
        receiveTimeout:const Duration(minutes: 1),);
      Dio.Dio dio=Dio.Dio(options);
        dio.interceptors.add(DioCacheInterceptorHelper.getCacheInterceptor());
      Dio.Response response=await dio.get("${url}");
      dio.interceptors
        ..add(retryInterceptor(dio))
        ..add(InterceptorsWrapper(onResponse: responseInterceptor));
      print("${response.statusCode}");
      if(response.statusCode==200){
        print("${BaseUrl}${endpoint} >>>Response ::  ${response.data}");
        onData(response);
      }else{
        print("${response.data}");
        print("${response.statusMessage}");
        AppUtil.dismissLoading();
        onError(response);
      }
      return response;
    }catch(e,s){

      AppUtil.dismissLoading();

      if(e is DioException){

        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Something went wrong");
          AppUtil.dismissLoading();
        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
        }
        else if((e as DioException).response ==null){
          AppUtil.showToastError('Server is not connecting in 10 ms');
          AppUtil.dismissLoading();
        }
        else{
          unAthorized((e as DioException).response?.statusCode);
          onError((e as DioException).response);
        }

      }else{
        AppUtil.showToastError('${e}');
        AppUtil.dismissLoading();
      }
      print("------- ${e}");
    }

  }
  static Future postRequest({required String endpoint,Object? body,required Function(dynamic) onData,required Function(dynamic) onError})async{
    try{
      print("${BaseUrl}${endpoint}");
      print("params ${jsonEncode(body)}");
      Map<String,String>? map;
      var data = LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }
      if(map==null){
        map={};
      }

      print("accessToken ${map}");
      BaseOptions options=BaseOptions(headers: map,connectTimeout:const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),);
      Dio.Dio dio=Dio.Dio(options);

      dio.post(BaseUrl+"${endpoint}",data: body).then((response){
        print("${response.data}");
        if(response.statusCode==200 || response.statusCode==304){
          AppUtil.dismissLoading();
          onData(response);
        }else{
          print("Error >>>> ${jsonEncode(response.data)}");
          onError(response);
        }
      }).catchError((e,s){
        postError(e, onError);
      });


    }catch(e,s){
      print("Url ---->>>  ${BaseUrl}${endpoint}  ${e}");
      postError(e, onError);
    }
  }
  static Future deleteRequest({required String endpoint,Map? body,required Function(dynamic) onData,required Function(dynamic) onError})async{
    try{
      Map<String,String>? map;

      var data = await LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }if(map==null){
        map={};
      }
      map['language']='${getLanguage()}';

      print("${BaseUrl}${endpoint}");
      print("params ${body}");

      BaseOptions options=BaseOptions(headers: map,connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout:const Duration(milliseconds: 10000),);
      Dio.Dio dio=Dio.Dio(options);
      var response = await dio.delete(BaseUrl+"${endpoint}",);
      dio.interceptors..add(retryInterceptor(dio))
        ..add(InterceptorsWrapper(onResponse: responseInterceptor));

      print("${response.statusCode}");
      if(response.statusCode! >=200 && response.statusCode! <=301){
        print("${response.data}");
        onData(response);
      }else{
        print("${response.data}");
        onError(response);
      }
    }catch(e,s){
      print("Url ---->>>  ${BaseUrl}${endpoint}  ${e}");
      if(e is DioException){
        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Something went wrong");
          AppUtil.dismissLoading();
        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
        }
        else if((e as DioException).response ==null){
          AppUtil.showToastError('Server is not connecting in 10 ms');
          AppUtil.dismissLoading();
        }
        else{
          unAthorized((e as DioException).response?.statusCode);
          onError((e as DioException).response);
        }
      }else{
        AppUtil.showToastError(e.toString());
        AppUtil.dismissLoading();
      }
    }
  }
  static Future multipartRequest({required String endpoint,required Map<String,dynamic> body,required Function(dynamic) onData,required Function(dynamic) onError})async{
    try{
      print("${endpoint}");
      Map<String,String>? map;
      var data = LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }if(map==null){
        map={};
      }
      map['language']='${getLanguage()}';

      print("${body}");
      FormData formData = FormData.fromMap(body);
      print("${formData.fields}");
      BaseOptions options=BaseOptions(headers: map,connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout:const Duration(milliseconds: 10000),);
      Response response=await Dio.Dio(options).post("${BaseUrl+endpoint}",data: formData,);
      if(response.statusCode==200|| response.statusCode==304){
        onData(response);
      }else{
        onError(response);
      }
    }catch(e,s){
      print("Url ---->>>  ${BaseUrl}${endpoint}  ${e}");
      debugPrint("ErrorMultipart  ${e}");
      if(e is DioException){
        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Unable to connect Server");
          AppUtil.dismissLoading();
        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
        }else{
          unAthorized((e as DioException).response?.statusCode);
          onError((e as DioException).response);
        }
      }else{
        AppUtil.showToastError("${e}");
        AppUtil.dismissLoading();
      }
    }

  }
  static Future getRequestFuture({required String endpoint,String? query,required Function(dynamic) onData,required Function(dynamic) onError})async{
    try{
      String url="";
      if(query==null) {
        url="${endpoint}";
        print("${endpoint}");
      }else{
        url="${endpoint}${query}";

      }
      print(url);
      Map<String,String>? map;
      var data = await LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }if(map==null){
        map={};
      }
      map['language']='${getLanguage()}';

      print("accessToken ${map}");
      BaseOptions options=BaseOptions(headers: map,connectTimeout:const Duration(milliseconds: 75000),
        receiveTimeout:const Duration(milliseconds: 75000),);
      Dio.Dio instance=Dio.Dio(options);
      Dio.Response response=await instance.get("${url}");

      if(response.statusCode==200){
        onData(response);
      }else{
        AppUtil.dismissLoading();
        // httpUnotherized(response);

        onError(response);
      }
      return response;
    }catch(e,s){
      print("Url ---->>>  ${BaseUrl}${endpoint}  ${e}");
      AppUtil.dismissLoading();
      if(e is DioException){

        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Something went wrong");
          AppUtil.dismissLoading();
          // onError(e);

        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
          // onError(e);

        }
        else if((e as DioException).response ==null){
          AppUtil.showToastError('Server is not connecting in 10 ms');
          AppUtil.dismissLoading();
          // onError(e);

        }
        else{
          unAthorized((e as DioException).response?.statusCode);
          // onError((e as DioException).response);
        }

      }else{
        // AppUtil.showToastError(e.toString());
        AppUtil.dismissLoading();

      }
      print("------- ${e}");
      onError(e);
    }

  }
  static Stream<Response<dynamic>> getRequestStreamNew({required String endpoint,String? query,required Function(dynamic) onData,required Function(dynamic) onError})async*{
    print("StreamProgramming 3");
    try{
      String url="";
      if(query==null) {
        url="${BaseUrl}${endpoint}";
        print("${BaseUrl}${endpoint}");
      }else{
        url="${BaseUrl}${endpoint}${query}";

      }
      print(url);
      Map<String,String>? map;
      var data = LocalStorageHelper.getData(key: "accessToken");
      if(!(data==null)) {
        map = {"Authorization": "${data}"};
      }
      if(map==null){
        map={};
      }
      map['language']='${getLanguage()}';

      print("accessToken ${map}");
      print("${url}");
      BaseOptions options=BaseOptions(headers: map,connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout:const Duration(milliseconds: 15000),);
      Dio.Dio dio=Dio.Dio(options);
      Dio.Response response=await dio.get("${url}");
      dio.interceptors..add(retryInterceptor(dio))
        ..add(InterceptorsWrapper(onResponse: responseInterceptor));

      print("${response.statusCode}");
      if(response.statusCode==200|| response.statusCode==304){
        print("${response.data}");
        onData(response);
      }else{
        print("${response.data}");
        print("${response.statusMessage}");
        onError(response);
      }
      yield response;
    }catch(e,s){
      print("Url ---->>>  ${BaseUrl}${endpoint}  ${e}");

      if(e is DioException){
        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Server is not working");
          AppUtil.dismissLoading();
        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
        }else{
          unAthorized((e as DioException).response?.statusCode);
          onError((e as DioException).response);
        }
      }else{
        AppUtil.showToastError("${e}");
        AppUtil.dismissLoading();
      }
      print("------- ${e}");
      //onError(e);
    }

  }

  static getFile(dynamic path,String name)async{
    return await Dio.MultipartFile.fromFile(path.path,filename: '${name}');
  }
  static  void downloadFile(String nameUrl,String imgUrl,Function(String) callback,{String? extension})  {
    print("${imgUrl}");
    try {
      Dio.Dio dio = Dio.Dio();
      var len=(Uri.parse(nameUrl)).pathSegments.length;
      String fName='Cyan${DateTime.now().microsecond}';
      print("downloadFile   ${fName}");
      getFilePath("${fName}${extension==null?'':'.${extension}'}",(s){

        print("${s}");
        dio.download(imgUrl,"${s}",onReceiveProgress: (rec,total){
          print("${rec}  ${s}  ${total}");
          if(rec==total) {
            var file = File(s);

            print("Path is --- ${file.isAbsolute}/ ${file.absolute.path}\n ${s}\n${file.uri.toFilePath()}\n ${file.uri.path}");

            callback("${s}");
          }


        }).catchError((e){

          print("${e}");
          AppUtil.dismissLoading();
          AppUtil.showToastError("No file exist");
          debugPrint("${e}");
        });
      });
    } catch(e,s){
      print("Url ---->>>  ${BaseUrl}${nameUrl}  ${e}");
      if(e is DioException){
        if((e as DioException).type == DioExceptionType.connectionTimeout){
          AppUtil.showToastError("Server is not working");
          AppUtil.dismissLoading();
        }else if((e as DioException).error is SocketException){
          AppUtil.showToastError("Please check you internet");
          AppUtil.dismissLoading();
        }
        else{
          unAthorized((e as DioException).response?.statusCode);
        }
      }else{
        AppUtil.showToastError("${e}");
        AppUtil.dismissLoading();
      }

      print(e.toString());
    }
  }
  static void getFilePath(String name,Function(String) callback) async {
    if(Platform.isAndroid){
      getTemporaryDirectory().then((dir){
        print("${dir}");


        callback('${dir?.path}/${name}');
      }).catchError((e){
        print("${e}");
        AppUtil.showToastError("${e}");
      });
    }else{
      getApplicationDocumentsDirectory().then((dir){
        print("${dir}");
        callback('${dir?.path}/${name}');
      }).catchError((e){
        print("${e}");
        AppUtil.showToastError("${e}");
      });
    }
  }

  static requestInterceptor(RequestOptions options,RequestInterceptorHandler handler) {}
  static responseInterceptor(Response<dynamic> response, ResponseInterceptorHandler handler) {

    if(response.statusCode==401){
      handler.next(response);

    }else{
      handler.next(response);
    }
  }
  static errorInterceptor(DioException dioError, ErrorInterceptorHandler onError) {}
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.receiveTimeout &&
        err.error != null &&
        err.error is SocketException;
  }
  static Interceptor retryInterceptor(Dio.Dio dio){
    return RetryInterceptor(
      dio: dio,
      retryableExtraStatuses: {
        // APIErrorCodeHandler.NetworkConnectTimeoutError,
        APIErrorCodeHandler.InternalServerError,
        // APIErrorCodeHandler.ConnectionTimedOut,
        // APIErrorCodeHandler.TimeoutOccurred,
        // APIErrorCodeHandler.SSLHandshakeFailed,
        // APIErrorCodeHandler.NetworkReadTimeoutError,

      },
      logPrint: print, // specify log function (optional)
      retries: 1, // retry count (optional)
      retryDelays: const [ // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        // Duration(seconds: 2), // wait 2 sec before second retry
        // Duration(seconds: 3), // wait 3 sec before third retry
      ],
    );
  }
  static void unAthorized(int? code){

    if(code==401){

    }
  }
  static String getLanguage(){
    return "en";
  }
  static void postError(Object e, onError(dynamic )) {
    AppUtil.dismissLoading();

    if(e is DioException){
      if((e as DioException).type == DioExceptionType.connectionTimeout){
        AppUtil.showToastError("Server is not working");
      }else if((e as DioException).error is SocketException){
        AppUtil.showToastError("Please check you internet");
      }else{
        if( (e as DioException).response?.statusCode==null ||(!((e as DioException).response?.statusCode==null)&&499==(e as DioException).response?.statusCode)&&500<(e as DioException).response!.statusCode!) {
          AppUtil.showToastError("Server is not responding in 10 sec");
        }else{
          debugPrint('${(e as DioException).response?.data}');
          if((e as DioException).response?.data is String) {
            AppUtil.showToastError(
                "${(e as DioException).response?.data}");
          }else{
            AppUtil.showToastError(
                "${(e as DioException).response?.data['msg'] == null
                    ? (e as DioException).response?.data['message']
                    : (e as DioException).response?.data['msg']}");
          }
        }
        unAthorized((e as DioException).response?.statusCode);
        onError((e as DioException).response);
      }
    }
    else{
      AppUtil.showToastError("${e}");
      // AppUtil.dismissLoading();
    }
  }

}