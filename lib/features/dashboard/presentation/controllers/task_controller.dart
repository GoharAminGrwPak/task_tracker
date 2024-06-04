import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/domain/entities/project_type_entity.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/create_project_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/create_task_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_project_usecase.dart';

import 'project_controller.dart';

class TaskController extends GetxController{
  TextEditingController taskNameController=TextEditingController();
  TextEditingController taskDescController=TextEditingController();
  TextEditingController taskStatusController=TextEditingController();
  TextEditingController taskProrityController=TextEditingController();
  TextEditingController taskDurationUnitController=TextEditingController();
  TextEditingController taskDurationController=TextEditingController();
  TextEditingController dueDateController=TextEditingController();
  TextEditingController startDateTimeController=TextEditingController();

  GlobalKey<PopupMenuButtonState<String>>  statusKey=GlobalKey();
  GlobalKey<PopupMenuButtonState<String>>  prorityKey=GlobalKey();
  GlobalKey<PopupMenuButtonState<String>>  durationKey=GlobalKey();
  String? projectId;
  String? projectName;
  List<String> status=[
    AppString.todo.tr,
    AppString.in_progress.tr,
    AppString.in_discussion.tr,
    AppString.in_review.tr,
    AppString.done.tr,
    AppString.next_release.tr,
    AppString.reopen.tr,
    AppString.close.tr,
  ];
  List<String> prority=[
  AppString.normal.tr,
  AppString.medium.tr,
  AppString.high.tr,
  AppString.urgent.tr,
  ];
  List<String> durationUnit=[
  AppString.minute.tr,
  AppString.day.tr,
  ];
  List<int> statusCode=[0, 1, 2, 3, 4, 5,6,7];
  List<int> prorityCode=[1, 2, 3, 4,];
  List<int> durationCode=[1, 2, 3,];
  String? id;
  setDefault(){
    id=null;
    taskNameController.text='';
    taskDescController.text='';
    taskProrityController.text='${prority.first}';
    taskStatusController.text='${status.first}';
    taskDurationUnitController.text='';
    taskDurationController.text='';
    dueDateController.text='';
    startDateTimeController.text='';
  }
  createTask(){
    if(taskNameController.text.trim().isEmpty){
      AppUtil.showToastError('${AppString.project_name_hint}'.tr);
      return;
    }
    Map<String,dynamic> map={
      'content': '${taskNameController.text}',
    };
    if(taskDescController.text.isNotEmpty){
      map['description']='${taskDescController.text}';
    }

    if(taskProrityController.text.isNotEmpty){
      var indexWhere = prority.indexWhere((element) => element==taskProrityController.text);
      map['priority']='${prorityCode[indexWhere]}';
    }else{
      map['priority']='${prorityCode[00]}';
    }
    List<String> lables=["",""];
    if(taskStatusController.text.isNotEmpty){
      var indexWhere = status.indexWhere((element) => element==taskStatusController.text);
      lables[0]='${statusCode[indexWhere]}';
      map['labels']=[lables[0]];
    }else{
      lables[0]='${statusCode[0]}';
      map['labels']=[lables[0]];
    }

    if(startDateTimeController.text.isNotEmpty){
      map['due_date']='${startDateTimeController.text}';
    }
    if(dueDateController.text.isNotEmpty){
      lables[1]='${dueDateController.text}';
      map['labels']=[lables[0],lables[1]];
    }
    if(taskDurationController.text.isNotEmpty){
      if(taskDurationUnitController.text.isEmpty){
        AppUtil.showToastError(AppString.duration_unit_required.tr);
        return;
      }
      map['duration']='${taskDurationController.text}';
    }
    if(taskDurationUnitController.text.isNotEmpty){
      if(taskDurationController.text.isEmpty){
        AppUtil.showToastError(AppString.duration_required.tr);
        return;
      }
      var indexWhere = durationUnit.indexWhere((element) => element.toLowerCase()==taskDurationUnitController.text.toLowerCase());
      map['duration_unit']='${durationUnit[indexWhere]}'.toLowerCase();
    }


    if(null!=projectId &&AppDependency<ProjectController>().selectedType.value!=1){
      map['project_id']="${projectId}";
    }
    debugPrint('Result ${map.toString()}');
    // return;
    AppDependency<CreateTaskUseCase>().createTask(map,(dto){
      if(null==AppDependency<TaskController>().projectId) {
        Get.offAndToNamed(AppRoutes.newTaskStep3);
      }else{
        Get.back();
      }
    },id:id);
  }
  void setEditData(TaskEntity? task, TaskController taskController, String? prority, String? statusTicket, DateTime? dateVariable) {
    id=task?.id;
    if(null!=task?.content) {
      taskController.taskNameController.text = '${task?.content}';
    }
    if(null!=task?.description) {
      taskController.taskDescController.text='${task?.description}';
    }
    if(null!=prority) {
      taskController.taskProrityController.text='${prority}';
    }if(null!=statusTicket) {
      taskController.taskStatusController.text='${statusTicket}';
    }
    if(null!=task?.due?.string){
      taskController.startDateTimeController.text='${task?.due?.string}';
    }if(null!=task?.duration?.amount){
      taskController.taskDurationUnitController.text='${task?.due?.string}';
    }if(null!=task?.duration?.unit){
      taskController.taskDurationUnitController.text='${task?.duration?.unit}';
    }
    if(null!=dateVariable){
      taskController.dueDateController.text='${AppUtil.format(dateVariable)}';
    }
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescController.dispose();
    taskStatusController.dispose();
    taskProrityController.dispose();
    taskDurationUnitController.dispose();
    taskDurationController.dispose();
    startDateTimeController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}