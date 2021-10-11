import 'package:new_test/core/data/locator.dart';
import 'package:new_test/core/data/response_model/medication_model.dart';
import 'package:new_test/core/data/services/medication_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel{

  final MedicationService? _medicationService = serviceLocator<MedicationService>();

  Future<MedicationModel?> getMedication() async {
    MedicationModel? _apiResponse = await _medicationService!.getMedication();
    return _apiResponse;
  }

}