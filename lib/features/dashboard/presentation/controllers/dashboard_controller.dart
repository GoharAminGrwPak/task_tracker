import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/data/models/task_model.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/all_projects_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/all_tasks_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_project_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_task_usecase.dart';

class DashboardController extends GetxController{
  RxInt selectedIndex=1.obs;
  List<ProjectModelDto>? allProjects;
  List<TaskEntity>? allTasks;

  RxInt selectedProject=0.obs;
  RxInt selectedTask=0.obs;
  getAllProjects(){
    allProjects=null;
    allTasks=null;
    update(['root']);
    AppDependency<AllProjectsUseCase>().getAllProject((p0){
      allProjects=p0;
      update(['root']);
    });
  }
  getAllTasks({String? query}){
    allProjects=null;
    allTasks=null;
    update(['root','load_new_tasks']);
    AppDependency<AllTaskUseCase>().getAllTasks(query,(p0){
      if(null!=query) {
        allTasks=p0.where((e){
          debugPrint('getAllTasks ${e.projectId} == ${query}');
          return e.projectId==query;
        }).toList();
      }else {
        allTasks = p0;
      }
      update(['root','load_new_tasks']);
    });
  }
  deleteProject(index){
    var id = allProjects?[index].id;
    AppUtil.showConfirmationDialog(AppString.delete_project_desc, callback: (){
      AppDependency<DeleteProjectUseCase>().deleteProject('${id}',(){
        if(allProjects!.contains(allProjects![index])) {
          allProjects?.removeAt(index);
          selectedProject.value=0;
        }AppUtil.showToastSuccess('${AppString.succes_delete_message}');
        update(['root']);
      });
    });

  }
  deleteTask(index){
    var id = allTasks?[index].id;
    AppUtil.showConfirmationDialog(AppString.delete_task_desc, callback: (){
      AppDependency<DeleteTaskUseCase>().deleteTask('${id}',(){
        if(allTasks!.contains(allTasks![index])) {
          allTasks?.removeAt(index);
          selectedTask.value=0;
        }AppUtil.showToastSuccess('${AppString.succes_delete_task_message}');
        update(['root']);
      });
    });

  }
}