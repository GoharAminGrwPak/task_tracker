import 'package:flutter/material.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/icons/app_icons.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';
class StepsIndicator extends StatelessWidget {
  int numSelected;
  Function? callback;

  StepsIndicator(this.numSelected,{this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: [

            Align(
              alignment: AlignmentDirectional.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stepWidget(
                      1,
                      numSelected == 1
                          ? 2
                          : numSelected > 1
                          ? 3
                          : 1),
                  stepWidget(
                      2,
                      numSelected == 2
                          ? 2
                          : numSelected > 2
                          ? 3
                          : 1),
                  stepWidget(
                      3,
                      numSelected == 3
                          ? 2
                          : numSelected > 3
                          ? 3
                          : 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepWidget(int numStep, int isDone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration:BoxDecoration(
            border: isDone == 3
                ? Border.all(color: ColorConstants.mainColor,)
                : isDone == 2
                ? Border.all(color: ColorConstants.mainColor,)
                :Border.all(color: ColorConstants.greyColor,),
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child:  Center(child: Text('${numStep}',)),
        ),
        numStep != 3
            ? line(isDone)
            : Container(
          width: 0,
        )
      ],
    );
  }

  Center stepDone() {
    return Center(
          child: Icon(
            AppIcons.check,
            size: 15,
          ),
        );
  }

  Widget line(int status) {
    return Container(
      height: 6,
      width: 35,
      color: Color.fromARGB(26, 255, 255, 255),
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                  decoration: status == 2
                      ? BoxDecoration(
                      color: ColorConstants.mainColor,
                      borderRadius: BorderRadius.only(topRight:Radius.circular(60),bottomRight: Radius.circular(60))
                  )
                      : status == 3
                      ? BoxDecoration(
                    color: ColorConstants.mainColor,
                  )
                      : null)),
          Flexible(
              flex: 1,
              child: Container(
                  decoration: status == 3
                      ? BoxDecoration(
                    color:ColorConstants.mainColor,
                  )
                      : null)),
        ],
      ),
    );
  }
}