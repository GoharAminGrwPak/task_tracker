import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/loader/loader_layout.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/widgets/next_button.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/no_information_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/tab_bar_item_widget.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    var dashboardController = AppDependency<DashboardController>();
    var taskController = AppDependency<TaskController>();

    return  Scaffold(
      appBar: AppBar(title: Text(AppString.projects_app_bar.tr),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
         getTabBar(dashboardController),
          SizedBox(height: 10,),
          Expanded(
            child: GetBuilder(
                init: dashboardController,
                id: 'root',
                initState: (_){
                  Future.delayed(Duration(milliseconds: 100),(){
                    dashboardController.getAllProjects();
                  });

                },
                builder: (_){
              return dashboardController.selectedIndex.value==0?
              allProjects(dashboardController):
              AllTasksWidget(dashboardController.allTasks,dashboardController.selectedTask,actionCallback: (index){
                dashboardController.selectedTask.value=index;
                AppDependency<ProjectController>().selectedType.value=2;
                taskController.projectId = dashboardController.allTasks?[index].projectId;
                taskController.projectName=null;
                Get.toNamed(AppRoutes.newTaskStep2)?.then((value){
                  dashboardController.getAllTasks();
                });
              },deleteCallback: (index){
                dashboardController.deleteTask(index);
              });
            }),
          )
        ],),
      ),
      bottomNavigationBar: GetBuilder(
          init: dashboardController,
          id: 'root',
          builder: (DashboardController controller) {
            return ((dashboardController.allProjects?.length??0)>0)?InkWell(onTap:(){
              AppDependency<ProjectController>().selectedType.value=2;
              taskController.projectId="${dashboardController.allProjects?[dashboardController.selectedProject.value].id}";
              taskController.projectName='${dashboardController.allProjects?[dashboardController.selectedProject.value].name}';
              Get.toNamed(AppRoutes.allTasks)?.then((value){
                dashboardController.getAllTasks();
              });
            },child: NextButtonWidget(title: '${AppString.select}'.tr)):SizedBox(height: 0,width: 0,);
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.toNamed(AppRoutes.newTaskStep1);
      }, child: Icon(Icons.add),),
    );
  }

  StatelessWidget allProjects(DashboardController dashboardController) {
    if(dashboardController.allProjects==null){
      return LoaderLayout(Get.width);
    }
    else if((dashboardController.allProjects?.length??0)==0){
      return NoInformationWidget(msg: AppString.projects_no_data.tr,);
    }
    else if((dashboardController.allProjects?.length??0)>0){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: dashboardController.allProjects?.length??0,
          itemBuilder: (_,index){
        return InkWell(
          onTap: (){
            dashboardController.selectedProject.value=index;
          },
          child: Obx(() => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: index==dashboardController.selectedProject.value?ColorConstants.mainColor.withOpacity(0.2):Colors.transparent
            ),
            child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Container(
                    padding: EdgeInsets.all( 4),
                    decoration:BoxDecoration(
                        border: Border.all(color: ColorConstants.mainColor),
                        shape: BoxShape.circle
                    ) ,
                    child: Icon(AppIcons.type1Icon,color: ColorConstants.mainColor,size: 18,)),
                title: Text('${dashboardController.allProjects?[index].name}'),
                trailing: InkWell(onTap:(){
                  dashboardController.deleteProject(index);
                },child: Icon(AppIcons.deleteIcon,color: ColorConstants.redColorAccent,size: 18,))),
          )),
        );

      });
    }else {
      return NoInformationWidget(msg: AppString.something_went_wrong.tr,);
    }
  }

  Widget getTabBar(DashboardController dashboardController) {
    return Obx(() =>
         Row(
       children: [
         Expanded(
           child: InkWell(onTap:(){
             dashboardController.selectedIndex.value=1;
             dashboardController.getAllTasks();
           },child: TabBarItemWidget(1, dashboardController.selectedIndex.value,'${AppString.task}')),
         ),
         SizedBox(width: 10,),
         Expanded(
           child: InkWell(onTap:(){
             dashboardController.selectedIndex.value=0;
             dashboardController.getAllProjects();

           },child: TabBarItemWidget(0, dashboardController.selectedIndex.value,'${AppString.project}')),
         ),


       ],
     ));
  }
}
class AllTasksWidget extends StatelessWidget {
  List<TaskEntity>? allTasks;
  RxInt selectedTask;
  Function(int index)? actionCallback;Function(int index)? deleteCallback;
   AllTasksWidget(this.allTasks,this.selectedTask,{this.actionCallback,this. deleteCallback});

  @override
  Widget build(BuildContext context) {
    var taskController = AppDependency<TaskController>();

    if(allTasks==null){
      return LoaderLayout(Get.width);
    }
    else if((allTasks?.length??0)==0){
      return NoInformationWidget(msg: AppString.projects_no_data.tr,);
    }
    else if((allTasks?.length??0)>0){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: allTasks?.length??0,
          itemBuilder: (_,index){
            DateTime? dateVariable;
            String? otherVariable;
            String? prority;
            String? statusTicket;
            if((allTasks?[index].labels?.length??0)>0) {
              for (var item in allTasks![index].labels!) {
                // Check if the item can be parsed to a DateTime
                DateTime? date = DateTime.tryParse(item);
                if (date != null) {
                  dateVariable = date;
                } else {
                  otherVariable = item;

                }
              }
            }
            if(null!=allTasks?[index].priority) {
              var indexWhere = taskController.prorityCode.indexWhere((element) => element== allTasks?[index].priority);
              if(indexWhere>-1) {
                prority=taskController.prority[indexWhere];
              }
            }
            if(null!=otherVariable) {
              var indexWhere = taskController.statusCode.indexWhere((element) => '$element' == '$otherVariable');
              if(indexWhere>-1) {
                statusTicket=taskController.status[indexWhere];
              }
            }
            return InkWell(
              onTap: (){
                var task = allTasks?[index];
                taskController.setEditData(task, taskController, prority, statusTicket, dateVariable);
                actionCallback?.call(index);
                // dashboardController.selectedTask.value=index;
              },
              child: Obx(() => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: index==selectedTask.value?ColorConstants.mainColor.withOpacity(0.2):Colors.transparent
                ),
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Container(
                        padding: EdgeInsets.all( 4),
                        decoration:BoxDecoration(
                            border: Border.all(color: ColorConstants.mainColor),
                            shape: BoxShape.circle
                        ) ,
                        child: Icon(AppIcons.type2Icon,color: ColorConstants.mainColor,size: 18,)),
                    title: Text('${allTasks?[index].content}'),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(null!=allTasks?[index].description &&''!=allTasks?[index].description)Text('${allTasks?[index].description}'),
                        if(null!=prority)Text('${prority}'),
                        if(null!=statusTicket)Text('${statusTicket}'),
                        if(null!=allTasks?[index].duration?.amount)
                          Text('${allTasks?[index].duration?.amount}'),
                        if(null!=allTasks?[index].duration?.unit)Text('${allTasks?[index].duration?.unit}'),
                        if(null!=allTasks?[index].due?.string)Text('Start time ${allTasks?[index].due?.string}'),
                        if(null!=dateVariable)Text('End time ${AppUtil.format(dateVariable)}'),
                      ],),
                    trailing: InkWell(onTap:(){
                      deleteCallback?.call(index);

                      // dashboardController.deleteTask(index);
                    },child: Icon(AppIcons.deleteIcon,color: ColorConstants.redColorAccent,size: 18,))),
              )),
            );

          });
    }else {
      return NoInformationWidget(msg: AppString.something_went_wrong.tr,);
    }
  }

}

