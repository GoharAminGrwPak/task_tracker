import 'package:task_tracker/bootstrap/injection_container.dart';
import 'package:task_tracker/features/dashboard/data/models/project_model_dto.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/project_repository.dart';

class CreateProjectUseCase{
  createProject(String name,Function(ProjectModelDto) onData){
    ProjectRepository projectRepository=AppDependency<ProjectRepository>();
    projectRepository.createProject(name,onData);
  }
}