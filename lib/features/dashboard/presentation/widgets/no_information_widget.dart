import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/widgets/custom_image_view.dart';
class NoInformationWidget extends StatelessWidget {
  final String msg;
  const NoInformationWidget({this.msg=''});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(AppIcons.no_information,size: 80,color: ColorConstants.greyColor.shade700,),
              Text(msg==''?"No Information Recorded".tr:'${msg}'.tr,style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.center,),
            ],
          ),
        ));
  }
}