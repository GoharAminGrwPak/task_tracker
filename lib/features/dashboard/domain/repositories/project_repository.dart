import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';

abstract class ProjectRepository{
  createProject(String name,Function(ProjectModelDto) onData);
  deleteProject(String id,Function() onData);
  getAllProjects(Function(List<ProjectModelDto>) onData);
}