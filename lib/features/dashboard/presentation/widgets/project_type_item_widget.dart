import 'package:flutter/material.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
import 'package:task_tracker/features/dashboard/domain/entities/project_type_entity.dart';

class ProjectTypeItemWidget extends StatelessWidget {
  final ProjectTypeEntity item;
  final int selectedIndex;
  const ProjectTypeItemWidget({
    required this.item,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: item.id==selectedIndex?ColorConstants.mainColor:Colors.transparent)
      ),
      margin: EdgeInsets.only(left: 10,right: 10,top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${item.name}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Row(children: [
            Container(
                padding: EdgeInsets.all( 6),
                decoration:BoxDecoration(
                    border: Border.all(color: ColorConstants.mainColor),
                    shape: BoxShape.circle
                ) ,
                child: Icon(item.icon,color: ColorConstants.mainColor,)),
            SizedBox(width: 10,),
            Expanded(child: Text('${item.description}',style: TextStyle(fontSize: 13),)),

          ],),
          SizedBox(height: 10,),

        ],),
    );
  }
}