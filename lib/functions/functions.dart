import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Functions {


  static Future<http.Response> postReq(String secondUrl, String params) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if(token == null)
      {
        print("SIGN IN");
        return null;
      }
    return http.post(
      Variables.baseUrl + secondUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token' : token
      },
      body: params,
    );


/*
    jsonEncode(<String, String>{
      'title': title,
    })*/
  }




   static Future<http.Response> unsignPostReq(String secondUrl, String params) {
    return http.post(
      Variables.baseUrl + secondUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: params,
    );
  }







}