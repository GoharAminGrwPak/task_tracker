import 'package:flutter/material.dart';
import 'package:task_tracker/core/network/api_request_http.dart';
import 'package:task_tracker/core/network/endppoint.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/data/models/task_model.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/task_repository.dart';
import 'package:dio/dio.dart' as dio;

class TaskRepositoryImpl extends TaskRepository{
  @override
  void createTask(Map<String, dynamic> map, Function(ProjectModelDto p1) onData,{String? id}) {
    ApiRequestHttp.postRequest(endpoint: id==null?'${ApiEndPoint.createTask}':'${ApiEndPoint.createTask}/${id}',
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
  getAllTasks(String? query,Function(List<TaskEntity> p1) onData,) {
    ApiRequestHttp.getRequest(endpoint: query==null?'${ApiEndPoint.createTask}':'${ApiEndPoint.createTask}?project_id=${query}',
        onData:(res){
          AppUtil.dismissLoading();
          List<TaskEntity>list=[];
          if(null!=(res as dio.Response).data){
            if((res as dio.Response).data is List){
              (res as dio.Response).data.forEach((element) {
                list.add(TaskModel.fromJson(element));
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
    ApiRequestHttp.deleteRequest(endpoint: '${ApiEndPoint.createTask}/${id}',
        onData:(res){
          AppUtil.dismissLoading();
          onData();
        }, onError: (e){}
    );
  }
}