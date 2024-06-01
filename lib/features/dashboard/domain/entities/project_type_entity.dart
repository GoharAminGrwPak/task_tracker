import 'package:flutter/cupertino.dart';

class ProjectTypeEntity{
  final id;
  final String name,description;
  final IconData icon;
  const ProjectTypeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
});
}