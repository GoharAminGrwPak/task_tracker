import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
class NextButtonWidget extends StatelessWidget {
  final title;
  const NextButtonWidget({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 10),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConstants.mainColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${title}'.tr,),
        ],
      ),
    );
  }
}