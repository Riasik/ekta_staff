import 'dart:convert';

import 'package:ekta/model/response.dart';
import 'package:ekta/utilities/constants.dart';
import 'package:http/http.dart' as http;
class ApiLogin {

  Future<Response> login({String input}) async {
    var queryParams = {
      'api_key': Constants.API_KEY,
      'user_phone': input};
    final response = await http.post(
        Constants.BASE_URI + Constants.SEND_VERIFICATION_CODE, body: queryParams);
    //print('$Constants.BASE_URI$Constants.SEND_VERIFICATION_CODE');
    //print('response: ${response?.body}');
    if(response.statusCode == 200){
      return Response.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
  Future<ResponseUser> cod({String input, String ref}) async {
    var queryParams;
    queryParams = {
      'api_key': Constants.API_KEY,
      'code': input,
      'ref': ref};
    final response = await http.post(
        Constants.BASE_URI + Constants.VERIFICATION_CODE, body: queryParams);
    if(response.statusCode == 200){
      return ResponseUser.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
}