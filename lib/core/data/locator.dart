import 'package:get_it/get_it.dart';
import 'package:new_test/core/data/services/medication_service.dart';
import 'package:new_test/core/data/services/medication_service_impl.dart';

GetIt serviceLocator = GetIt.instance;

setupLocator(){
  serviceLocator.registerLazySingleton<MedicationService>(() => MedicationServiceImpl());
}