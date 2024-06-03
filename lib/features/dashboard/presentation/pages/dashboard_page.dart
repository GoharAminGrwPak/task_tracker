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
import 'package:task_tracker/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/no_information_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/tab_bar_item_widget.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    var dashboardController = AppDependency<DashboardController>();
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
              allTasks(dashboardController);
            }),
          )
        ],),
      ),
      bottomNavigationBar: GetBuilder(
          init: dashboardController,
          id: 'root',
          builder: (DashboardController controller) {
            return ((dashboardController.allProjects?.length??0)>0)?NextButtonWidget(title: '${AppString.select}'.tr):SizedBox(height: 0,width: 0,);
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
  StatelessWidget allTasks(DashboardController dashboardController) {
    var taskController = AppDependency<TaskController>();

    if(dashboardController.allTasks==null){
      return LoaderLayout(Get.width);
    }
    else if((dashboardController.allTasks?.length??0)==0){
      return NoInformationWidget(msg: AppString.projects_no_data.tr,);
    }
    else if((dashboardController.allTasks?.length??0)>0){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: dashboardController.allTasks?.length??0,
          itemBuilder: (_,index){
            DateTime? dateVariable;
            String? otherVariable;
            String? prority;
            String? statusTicket;
            if((dashboardController.allTasks?[index].labels?.length??0)>0) {
              for (var item in dashboardController.allTasks![index].labels!) {
    // Check if the item can be parsed to a DateTime
    DateTime? date = DateTime.tryParse(item);
    if (date != null) {
      dateVariable = date;
    } else {
      otherVariable = item;

    }
  }
            }
            if(null!=dashboardController.allTasks?[index].priority) {
              var indexWhere = taskController.prorityCode.indexWhere((element) => element== dashboardController.allTasks?[index].priority);
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
            dashboardController.selectedTask.value=index;
          },
          child: Obx(() => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: index==dashboardController.selectedTask.value?ColorConstants.mainColor.withOpacity(0.2):Colors.transparent
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
                title: Text('${dashboardController.allTasks?[index].content}'),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(null!=dashboardController.allTasks?[index].description &&''!=dashboardController.allTasks?[index].description)Text('${dashboardController.allTasks?[index].description}'),
                    if(null!=prority)Text('${prority}'),
                    if(null!=statusTicket)Text('${statusTicket}'),
                    if(null!=dashboardController.allTasks?[index].duration?.amount)
                      Text('${dashboardController.allTasks?[index].duration?.amount}'),
                    if(null!=dashboardController.allTasks?[index].duration?.unit)Text('${dashboardController.allTasks?[index].duration?.unit}'),
                    if(null!=dashboardController.allTasks?[index].due?.string)Text('Start time ${dashboardController.allTasks?[index].due?.string}'),
                    if(null!=dateVariable)Text('End time ${AppUtil.format(dateVariable)}'),
                ],),
                trailing: InkWell(onTap:(){
                  dashboardController.deleteTask(index);
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
             dashboardController.selectedIndex.value=0;
             dashboardController.getAllProjects();

           },child: TabBarItemWidget(0, dashboardController.selectedIndex.value,'${AppString.project}')),
         ),
         SizedBox(width: 10,),
         Expanded(
           child: InkWell(onTap:(){
             dashboardController.selectedIndex.value=1;
             dashboardController.getAllTasks();
           },child: TabBarItemWidget(1, dashboardController.selectedIndex.value,'${AppString.task}')),
         ),
       ],
     ));
  }
}
