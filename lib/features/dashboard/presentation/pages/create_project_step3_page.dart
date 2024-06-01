import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/widgets/next_button.dart';
import 'package:task_tracker/core/common/widgets/step_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/no_information_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/project_type_item_widget.dart';
class CreateProjectSuccessPage extends StatelessWidget {
  const CreateProjectSuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    var projectController = AppDependency<ProjectController>();
    return  Scaffold(
      appBar: AppBar(title: Text(AppString.create_project.tr),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          StepsIndicator(3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(AppIcons.check_circle,size: 100,color: ColorConstants.successColor,),
              Text("${projectController.projectNameController.text} ${'${AppString.project_success}'.tr}".tr)
            ],),
          )
        ],),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          Get.back();
          Get.back();
        }, child: NextButtonWidget(title: AppString.home,)),
    );
  }
}



