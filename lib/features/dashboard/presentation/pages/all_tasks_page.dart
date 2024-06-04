import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/widgets/next_button.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/pages/dashboard_page.dart';
class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    var taskController = AppDependency<TaskController>();
    var projectController = AppDependency<ProjectController>();
    var dashboardController = AppDependency<DashboardController>();
    return  Scaffold(
      appBar: AppBar(title: Text('${taskController.projectName}'),),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
        child: GetBuilder(
            init: dashboardController,
            id: 'root',
            initState: (_){
              Future.delayed(Duration(milliseconds: 100),(){
                dashboardController.getAllTasks(query:taskController.projectId );
              });

            },
            builder: (_){
            return AllTasksWidget(dashboardController.allTasks, dashboardController.selectedTask,actionCallback: (index){
              dashboardController.selectedTask.value=index;
              AppDependency<ProjectController>().selectedType.value=2;
              taskController.projectName=null;
              taskController.projectId = dashboardController.allTasks?[index].id;
              Get.toNamed(AppRoutes.newTaskStep2)?.then((value){
                dashboardController.getAllTasks();
              });
            },deleteCallback: (index){
              dashboardController.deleteTask(index);
            });
          }
        ),
      ),
      bottomNavigationBar: InkWell(
          onTap: (){
            Get.toNamed(AppRoutes.newTaskStep2);
            taskController.setDefault();
          }, child: NextButtonWidget(title: AppString.create_new,)),
    );
  }
}
