import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/core/common/lables/app_strings.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppString.app_name}'.tr),
        backgroundColor: ColorConstants.mainColor,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildLanguageCard(
                'English',
                    () {
                  Get.updateLocale(Locale('en', 'US'));
                },
                Icons.language,
              ),
              SizedBox(height: 15),
              _buildLanguageCard(
                'عربى',
                    () {
                  Get.updateLocale(Locale('ar', 'AE'));
                },
                Icons.language,
              ),
              SizedBox(height: 15),
              _buildLanguageCard(
                'Türkçe',
                    () {
                  Get.updateLocale(Locale('tr', 'TR'));
                },
                Icons.language,
              ),
              SizedBox(height: 15),
              _buildLanguageCard(
                'اردو',
                    () {
                  Get.updateLocale(Locale('ur', 'PK'));
                },
                Icons.language,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String text, VoidCallback onPressed, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: ColorConstants.mainColor),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: ColorConstants.mainColor),
        onTap: onPressed,
      ),
    );
  }
}
