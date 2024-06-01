import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/project_repository.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/task_repository.dart';

class DeleteTaskUseCase{
  deleteTask(String id,Function() onData){
    TaskRepository repository=AppDependency<TaskRepository>();
    repository.deleteProject(id,onData);
  }
}