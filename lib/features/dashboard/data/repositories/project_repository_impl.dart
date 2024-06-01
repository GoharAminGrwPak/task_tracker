 import 'package:flutter/cupertino.dart';
import 'package:task_tracker/core/network/api_request_http.dart';
import 'package:task_tracker/core/network/endppoint.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/project_repository.dart';
import 'package:dio/dio.dart' as dio;
class ProjectRepositoryImpl extends ProjectRepository{
  @override
  createProject(String name,Function(ProjectModelDto) onData) {
    Map<String,dynamic> map={ "name": "projectName"};
     ApiRequestHttp.postRequest(endpoint: '${ApiEndPoint.createProject}',
        body: map,
        onData:(res){
      AppUtil.dismissLoading();
        var projectModelDto = ProjectModelDto.fromJson((res as dio.Response).data);
      onData(projectModelDto);
        debugPrint('ProjectRepositoryImpl >>onData> ${projectModelDto.toJson()}');
        },
        onError:(e){
          debugPrint('ProjectRepositoryImpl >>onError> ${e}');

        } );
  }

  @override
  getAllProjects(Function(List<ProjectModelDto> p1) onData) {
   ApiRequestHttp.getRequest(endpoint: '${ApiEndPoint.createProject}',
       onData:(res){
         AppUtil.dismissLoading();

         List<ProjectModelDto>list=[];
     if(null!=(res as dio.Response).data){
     if((res as dio.Response).data is List){
       (res as dio.Response).data.forEach((element) {
         list.add( ProjectModelDto.fromJson(element));
       });
       onData(list);
     }else{
       ProjectModelDto.fromJson((res as dio.Response).data);
     }
     }
     }, onError: (e){}
   );
  }

  @override
  deleteProject(String id, Function() onData) {
    ApiRequestHttp.deleteRequest(endpoint: '${ApiEndPoint.createProject}/${id}',
        onData:(res){
          AppUtil.dismissLoading();
          onData();
        }, onError: (e){}
    );

  }

}