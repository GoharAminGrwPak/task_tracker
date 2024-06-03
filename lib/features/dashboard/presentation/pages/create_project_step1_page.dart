import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/navigation/app_routes.dart';
import 'package:task_tracker/core/common/widgets/next_button.dart';
import 'package:task_tracker/core/common/widgets/step_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/no_information_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/project_type_item_widget.dart';
class CreateProjectTypePage extends StatelessWidget {
  const CreateProjectTypePage({super.key});
  @override
  Widget build(BuildContext context) {
    var projectController = AppDependency<ProjectController>();
    var taskController = AppDependency<TaskController>();
    return  Scaffold(
      appBar: AppBar(title: Text(AppString.create_project.tr),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(children: [
          StepsIndicator(1),
          Obx(() => Column(children: List.generate(projectController.typesList.length, (index) =>
              InkWell(
                  onTap: (){
                    projectController.selectedType.value=index+1;
                  },
                  child: ProjectTypeItemWidget(item: projectController.typesList[index], selectedIndex: projectController.selectedType.value))),))
        ],),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          AppDependency<TaskController>().projectId=null;
          AppDependency<TaskController>().projectName='';
          taskController.setDefault();
          Get.toNamed(AppRoutes.newTaskStep2);
        }, child: NextButtonWidget(title: AppString.next,)),
    );
  }
}



