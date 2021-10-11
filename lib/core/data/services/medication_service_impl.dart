import 'package:new_test/core/data/response_model/medication_model.dart';

import 'medication_service.dart';
import 'package:http/http.dart' as http;

class MedicationServiceImpl implements MedicationService{
  @override
  Future getMedication() async {
    //url
    var url = "https://run.mocky.io/v3/ccdca84e-819d-427d-af7d-4bfc1c25ee92";

    //post request
    try{
      final _client = http.Client();
      final response = await _client.get(Uri.parse(url),);
      //decode response
      if(response.statusCode == 200){
        final String responseString = response.body;
        return medicationModelFromJson(responseString);
      }
    }catch(e){
      print(e.toString());
    }
  }

}