import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
class LoaderLayout extends StatelessWidget {
  final width;
  final bool isCircular;
  const LoaderLayout(this.width,{this.isCircular=true});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            SpinKitThreeBounce(
            color: ColorConstants.mainColor,
            size: 30.0,
          ),
        ],
      ),
    );
  }
}