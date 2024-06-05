import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/loader/loader_layout.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/theme/theme_controller.dart';
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
    var projectController=AppDependency<ProjectController>();
    return  Scaffold(
      appBar: AppBar(
        title: Text(AppString.app_name.tr),
        actions: [
          IconButton(onPressed: (){
           Get.toNamed(AppRoutes.language);
          }, icon:Icon(Icons.language)),
          IconButton(onPressed: (){
            AppDependency<ThemeController>().toggleTheme();
          }, icon:
          AppDependency<ThemeController>().
          isDarkMode.value==true?Icon(Icons.light_mode_outlined):Icon(Icons.dark_mode_outlined)),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
        child: Column(children: [
         getTabBar(dashboardController),
          SizedBox(height: 10,),
          Expanded(
            child: GetBuilder(
                init: dashboardController,
                id: 'root',
                initState: (_){
                  Future.delayed(Duration(milliseconds: 100),(){
                    dashboardController.getAllTasks();
                    // dashboardController.getAllProjects();
                  });

                },
                builder: (_){
              return dashboardController.selectedIndex.value==0?
              allProjects(dashboardController):
              AllTasksWidget(dashboardController.allTasks,dashboardController.selectedTask,actionCallback: (index){
                dashboardController.selectedTask.value=index;
                taskController.projectId = dashboardController.allTasks?[index].projectId;

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
            return ((dashboardController.allProjects?.length??0)>0 ||(dashboardController.allTasks?.length??0)>0)?

            InkWell(onTap:(){
              if(dashboardController.selectedIndex.value==0) {
                projectController.selectedType.value = 2;
                taskController.projectId =
                "${dashboardController.allProjects?[dashboardController
                    .selectedProject.value].id}";
                taskController.projectName =
                '${dashboardController.allProjects?[dashboardController
                    .selectedProject.value].name}';
                Get.toNamed(AppRoutes.allTasks)?.then((value) {
                  dashboardController.getAllTasks();
                });
              }else{
                projectController.selectedType.value=2;
                taskController.projectName=null;
                Get.toNamed(AppRoutes.newTaskStep2)?.then((value){
                  dashboardController.getAllTasks();
                });
              }
            },child: NextButtonWidget(title: '${AppString.select}'.tr)):SizedBox(height: 0,width: 0,);
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        projectController.selectedType.value=dashboardController.selectedIndex.value==0?1:2;
        Get.toNamed(AppRoutes.newTaskStep1)?.then((value){
          if(value==true){
            if(dashboardController.selectedIndex.value==0) {
              dashboardController.getAllProjects();
            }else{
              dashboardController.getAllTasks();
            }
          }
        });
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
                    title: Text('${allTasks?[index].content}',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: subTitleWidget(index, prority, statusTicket, dateVariable),
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

  Column subTitleWidget(int index, String? priority, String? statusTicket, DateTime? dateVariable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (null != allTasks?[index].description && '' != allTasks?[index].description)
          Text(
            "${AppString.task_Description.tr} ${allTasks?[index].description}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        SizedBox(height: 12),
        Row(
          children: [
            if (null != priority)
              Expanded(
                child: Text(
                  "${'${AppString.task_prority}'.tr} ${priority}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (null != statusTicket)
              Expanded(
                child: Text(
                  "${'${AppString.task_status}'.tr} ${statusTicket}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        if (null != allTasks?[index].duration?.amount)SizedBox(height: 12),
        if (null != allTasks?[index].duration?.amount)
          Row(
            children: [
              if (null != allTasks?[index].duration?.unit)
                Text(
                  "${'Estimated Time'.tr} ${allTasks?[index].duration?.amount} ${allTasks?[index].duration?.unit}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        SizedBox(height: 12),
        if (null != allTasks?[index].due?.string) ...[
          Text("${AppString.time_spent.tr}", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("${AppString.start_time.tr}   ${allTasks?[index].due?.string}"),
          if (null != dateVariable) Text("${AppString.end_time.tr}     ${AppUtil.format(dateVariable)}"),
        ],
      ],
    );
  }

}

