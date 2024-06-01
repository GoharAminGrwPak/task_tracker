import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/domain/entities/project_type_entity.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/create_project_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_project_usecase.dart';

class ProjectController extends GetxController{
  RxInt selectedType=1.obs;
  TextEditingController projectNameController=TextEditingController();
  TextEditingController taskNameController=TextEditingController();
  TextEditingController taskDescController=TextEditingController();
  TextEditingController taskStatusController=TextEditingController();
  List<ProjectTypeEntity> typesList=[
    ProjectTypeEntity(
      id: 1,
      name: 'Project',
      icon: AppIcons.type1Icon,
      description: 'Create new Project and group the tasks'
    ),
    ProjectTypeEntity(
        id: 2,
      name: 'Task',
      icon: AppIcons.type2Icon,
      description: 'Create a Tt=ask without associating the project '
    ),
  ];
  setDefault(){
    projectNameController.text='';
    taskNameController.text='';
    selectedType=1.obs;
  }
  createProject(){
    if(projectNameController.text.trim().isEmpty){
      AppUtil.showToastError('${AppString.project_name_hint}'.tr);
      return;
    }
    AppDependency<CreateProjectUseCase>().createProject(projectNameController.text,(dto){
      Get.offAndToNamed(AppRoutes.newTaskStep3);
    });
  }

  @override
  void dispose() {
    projectNameController.dispose();
    taskNameController.dispose();
    taskDescController.dispose();
    taskStatusController.dispose();
    super.dispose();
  }
}