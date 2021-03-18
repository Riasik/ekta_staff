import 'dart:convert';
import 'dart:developer';

import 'package:ekta/model/response.dart';
import 'package:ekta/model/user.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:ekta/utilities/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Api {
  Map<String, dynamic> queryParams;
  Future<ResponseTabel> goToApi({String latitude, String longitude, String userId, User user}) async {
    if(latitude == null && longitude == null){
    Location location = Location();
    await location.getCurrentLocation();
    print(user.toString());
    //Map map = {'hi':'Hi'};
       queryParams = {
      'user': user.toMap(),
      'api_key': Constants.API_KEY,
      'user_id': userId,
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString()};
    }else{
       queryParams = {
        'user': user.toMap(),
        'api_key': Constants.API_KEY,
        'user_id': userId,
        'lat': latitude,
        'lon': longitude};
    }
    print('url: ${Constants.BASE_URI_LOCATION}');
    print('queryParams: $queryParams');
    var response = await (http.post(Constants.BASE_URI_LOCATION, body: json.encode(queryParams)));
    //print('response: $response');

    if(response.statusCode == 200){
      return ResponseTabel.fromJson(json.decode(response.body));
    }else{
       //'Error: ${response.body}';;
       Fluttertoast.showToast(
          msg: "Not in branches area!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
    }
  }
}