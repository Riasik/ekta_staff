import 'dart:convert';
import 'dart:developer';

import 'package:ekta/model/response.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:ekta/utilities/location.dart';
import 'package:http/http.dart' as http;

class Api {

  Future<ResponseTabel> goToApi({String latitude, String longitude, String userId}) async {
    Location location = Location();

    await location.getCurrentLocation();
    //Map map = {'hi':'Hi'};
    var queryParams = {
      'api_key': Constants.API_KEY,
      'user_id': userId,
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString()
    };
    print('url: ${Constants.BASE_URI_LOCATION}');
    print('queryParams: $queryParams');
    var response = await (http.post(Constants.BASE_URI_LOCATION, body: queryParams));
    //print('response: $response');

    if(response.statusCode == 200){
      return ResponseTabel.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error: ${response.reasonPhrase}');
    }
    //return ResponseTabel.fromJson(json.decode(response.body));
  }
}