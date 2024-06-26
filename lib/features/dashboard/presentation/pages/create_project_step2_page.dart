import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
import 'package:task_tracker/core/common/widgets/next_button.dart';
import 'package:task_tracker/core/common/widgets/step_widget.dart';
import 'package:task_tracker/core/utils/app_utils.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/no_information_widget.dart';
import 'package:task_tracker/features/dashboard/presentation/widgets/project_type_item_widget.dart';
class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});
  @override
  Widget build(BuildContext context) {
    var projectController = AppDependency<ProjectController>();
    var taskController = AppDependency<TaskController>();
    return  Scaffold(
      appBar: AppBar(title: Text(AppString.create_project.tr),),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
        child: GetBuilder(
          init: taskController,
          id: 'root',
          initState: (_){
            // taskController.setDefault();
          },
          builder: (_) {
            return ListView(children: [
              if(null==taskController.projectId)StepsIndicator(2),

              if(projectController.selectedType.value==1)
                getTextField(projectController.projectNameController,AppString.project_name,AppString.project_name_hint,isRequired: true)
              else Column(children: [
                SizedBox(height: 20,),
                if(null!=taskController.projectId&& null!=taskController.projectName)AbsorbPointer(child: getTextField(TextEditingController(text: '${taskController.projectName}'),AppString.project_name,AppString.task_name_hint,isRequired: true)),
                getTextField(taskController.taskNameController,AppString.task_name,AppString.task_name_hint,isRequired: true),
                SizedBox(height: 10,),

                getTextField(taskController.taskDescController,AppString.task_Description.tr,''),
                SizedBox(height: 10,),

                InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    taskController.statusKey.currentState!.showButtonMenu();
                  },
                  child: dropDownWidget(context,
                      taskController.taskStatusController,
                      AppString.task_status, '',
                      key: taskController.statusKey, list:taskController.status),
                ),
                SizedBox(height: 10,),

                InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    taskController.prorityKey.currentState!.showButtonMenu();
                  },
                  child: dropDownWidget(context,
                      taskController.taskProrityController,
                      AppString.task_prority, '',
                      key: taskController.prorityKey, list:taskController.prority),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('Estimated Time'.tr,style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children: [
                    Expanded(child: getTextField(taskController.taskDurationController, AppString.task_unit.tr,'')),
                    SizedBox(width: 10,),
                    Expanded(
            child: InkWell(
            onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
            taskController.durationKey.currentState!.showButtonMenu();
            },
            child: dropDownWidget(context,
            taskController.taskDurationUnitController,
            AppString.task_unit, '',
            key: taskController.durationKey, list:taskController.durationUnit),
                  ),
                )]),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('Developer Track Time'.tr,style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children: [
                    Expanded(child: InkWell( onTap: (){
                      AppUtil.selectDateTime(context, DateTime.now(), (p0) {
                        taskController.startDateTimeController.text='${AppUtil.format(p0)}';
                      });
                    },child: AbsorbPointer(child: getTextField(taskController.startDateTimeController,AppString.start_time.tr,'')))),
                    SizedBox(width: 10,),
                    Expanded(child: InkWell( onTap: (){
                      AppUtil.selectDateTime(context, DateTime.now(), (p0) {
                        taskController.dueDateController.text='${AppUtil.format(p0)}';
                      });

                    },child: AbsorbPointer(child: getTextField(taskController.dueDateController,AppString.end_time.tr,'')))),
                  ],
                ),
                SizedBox(height: 10,),
              ],),
            ],);
          }
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          if(projectController.selectedType.value==1) {
            projectController.createProject();
          }else{
            taskController.createTask();
          }
        }, child: NextButtonWidget(title: taskController.id==null?AppString.next:AppString.update_task,)),
    );
  }

  Widget getTextField(TextEditingController controller,String label,String hint,{bool isRequired=false,}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
              controller: controller,
              decoration:InputDecoration(
                border: outlineInputBorderNew,
                focusedBorder: outlineInputBorderNew,
                enabledBorder: outlineInputBorderNew,
                errorBorder: outlineInputBorderNew,
                label: Row(
                  children: [
                    Text(
                        label.tr
                    ),
                    if(isRequired)Text(
                      ' * ',
                      style: TextStyle(color: ColorConstants.redColorAccent),
                    ),
                  ],
                ),
                hintText:hint,
              ),
            ),
    );
  }
  Widget dropDownWidget(BuildContext context,
      TextEditingController controller,
      String label,String hint,
      {bool isRequired=false,required GlobalKey key,required List<String> list}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),

      child: AbsorbPointer(
        child: TextFormField(
                controller: controller,
                decoration:InputDecoration(
                  suffixIcon:PopupMenuButton<String>(
                    key: key,
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(value=="Select".tr){
                        controller.text="";
                        return;
                      }
                      controller.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return list.map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(
                            child: Text(value), value: value);
                      }).toList();
                    },
                  ),
                  border: outlineInputBorderNew,
                  focusedBorder: outlineInputBorderNew,
                  enabledBorder: outlineInputBorderNew,
                  errorBorder: outlineInputBorderNew,
                  label: Row(
                    children: [
                      Text(
                          label.tr
                      ),
                      if(isRequired)Text(
                        ' * ',
                        style: TextStyle(color: ColorConstants.redColorAccent),
                      ),
                    ],
                  ),
                  hintText:hint,
                ),
              ),
      ),
    );
  }
}
 const outlineInputBorderNew=OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.txtBoarderColor),borderRadius: BorderRadius.all(Radius.circular(6)));




