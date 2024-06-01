import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
class ActionLoader extends StatelessWidget {
  final color;
  const ActionLoader({this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color??ColorConstants.white,
      size: 20.0,
    );
  }
}
