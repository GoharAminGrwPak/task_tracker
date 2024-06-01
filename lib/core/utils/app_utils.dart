import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';

class AppUtil{
  static void showToastError(String message){
      Get.snackbar(
        'Error'.tr,
        '${message}'.tr,
        duration: Duration(seconds: 2),
        backgroundColor: ColorConstants.redColorAccent,
        colorText: Colors.white,
        animationDuration: Duration(milliseconds: 800),
        snackPosition: SnackPosition.BOTTOM,
      );
  }
  static void showToastSuccess(String message){
      Get.snackbar(
        'Suucces'.tr,
        '${message}'.tr,
        duration: Duration(seconds: 2),
        backgroundColor: ColorConstants.successColor,
        colorText: Colors.white,
        animationDuration: Duration(milliseconds: 800),
        snackPosition: SnackPosition.BOTTOM,
      );
  }
  static void dismissLoading(){

  }
  static showConfirmationDialog(String desc,{required Function callback}) {
    Get.defaultDialog(
      title: "${AppString.are_you_sure}".tr,
      middleText: "${desc}".tr,
      barrierDismissible: false,
      textCancel: "${AppString.no}".tr,
      textConfirm: "${AppString.yes}".tr,
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        Get.back();
        callback.call();
        // Close the dialog
      },
    );
  }
  static Future<void> selectDate(BuildContext context,
      DateTime initialDate,
      DateTime firstDate,
      DateTime lastDate,
      Function(DateTime) callback) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return child!;
        },
        context: context,
        initialDate: initialDate,
        initialEntryMode : DatePickerEntryMode.calendarOnly,
        firstDate: firstDate,
        lastDate:lastDate);
    if (picked != null) {
      callback(picked);
    }
  }
  static Future<void> selectDateTime(
      BuildContext context,
      DateTime initialDateTime,
      Function(DateTime?) callback,
      ) async {
    DateTime? selectedDateTime = initialDateTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: ColorConstants.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('${AppString.cancel}'.tr),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the modal
                    },
                  ),
                  CupertinoButton(
                    child: Text('${AppString.done}'.tr),
                    onPressed: () {
                      callback(selectedDateTime);
                      Navigator.of(context).pop(); // Close the modal
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: initialDateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDateTime = newDateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
static String format(DateTime? now){
  return now==null?'':'${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}';
}

}