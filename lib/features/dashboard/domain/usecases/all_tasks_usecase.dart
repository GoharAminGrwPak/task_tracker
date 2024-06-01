import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/domain/entities/task_entity.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/project_repository.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/task_repository.dart';

class AllTaskUseCase{
  getAllTasks(Function(List<TaskEntity>) onData){
    TaskRepository projectRepository=AppDependency<TaskRepository>();
    projectRepository.getAllTasks(onData);
  }
}