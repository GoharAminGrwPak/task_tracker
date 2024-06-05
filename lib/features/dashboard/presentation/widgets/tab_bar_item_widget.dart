import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
class TabBarItemWidget extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String label;
  const TabBarItemWidget(this.index,this.selectedIndex,this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: selectedIndex != index?Colors.transparent:ColorConstants.mainColor,
        border: Border.all(color: selectedIndex != index?ColorConstants.greyColor.shade200 : ColorConstants.mainColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Center(child: Text('$label'.tr)),
    );
  }
}
