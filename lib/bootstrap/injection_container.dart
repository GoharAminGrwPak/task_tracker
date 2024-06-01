import 'package:get_it/get_it.dart';
import 'package:task_tracker/features/dashboard/data/repositories/project_repository_impl.dart';
import 'package:task_tracker/features/dashboard/data/repositories/task_repository_impl.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/project_repository.dart';
import 'package:task_tracker/features/dashboard/domain/repositories/task_repository.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/all_projects_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/all_tasks_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/create_project_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/create_task_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_project_usecase.dart';
import 'package:task_tracker/features/dashboard/domain/usecases/delete_task_usecase.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/project_controller.dart';
import 'package:task_tracker/features/dashboard/presentation/controllers/task_controller.dart';
import '../features/dashboard/presentation/controllers/dashboard_controller.dart';
final AppDependency = GetIt.instance;
initDependencies(){
  //controller
  AppDependency.registerLazySingleton<DashboardController>(() => DashboardController());
  AppDependency.registerLazySingleton<ProjectController>(() => ProjectController());
  AppDependency.registerLazySingleton<TaskController>(() => TaskController());

  //Repositories
  AppDependency.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl());
  AppDependency.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());

  //usecases
  AppDependency.registerLazySingleton<CreateProjectUseCase>(() => CreateProjectUseCase());
  AppDependency.registerLazySingleton<AllProjectsUseCase>(() => AllProjectsUseCase());
  AppDependency.registerLazySingleton<DeleteProjectUseCase>(() => DeleteProjectUseCase());
  AppDependency.registerLazySingleton<CreateTaskUseCase>(() => CreateTaskUseCase());
  AppDependency.registerLazySingleton<AllTaskUseCase>(() => AllTaskUseCase());
  AppDependency.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase());

}

