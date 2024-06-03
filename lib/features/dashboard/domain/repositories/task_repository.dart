import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';

abstract class TaskRepository{
  void createTask(Map<String, dynamic> map, Function(ProjectModelDto) onData,{String? id});
  getAllTasks(String? query,Function(List<TaskEntity>) onData);
  deleteProject(String id,Function() onData);

}