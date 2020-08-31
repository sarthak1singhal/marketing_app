import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_web_view/flutter_web_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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


  }





  static Future<http.Response> getReq(String secondUrl, String params) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if(token == null)
    {
      print("SIGN IN");
      return null;
    }
    return http.get(
      Variables.baseUrl + secondUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token' : token
      },
     );


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



  static Widget showLoader(){
    return Center(child: Container(height: 50, width: 50, child: CircularProgressIndicator(),),);
  }


  static Widget backButton(context){
    return
    IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: (){
        Navigator.pop(context);
      },
    );


    /*GestureDetector(

      onTap: (){
        Navigator.pop(context);

      },
      child: Stack(

        children: <Widget>[
          Positioned(
            child: Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                color: Colors.black12,
                borderRadius: new BorderRadius.all(
                    const Radius.circular(50.0)),
              ),
            ),
            top: 12,
            left: 12,
          ),
          Positioned(
            child: Icon(Icons.clear),
            top: 20,
            left: 20,
          )
        ],
      ),
    );*/
  }

  static  Future<void> linkIgFromAllCamp(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account not verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Go to profile section and verify social media handles'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static bool isNullEmptyOrFalse(Object o) =>
      o == null || false == o || "" == o || 0==o;


  static getRedableNumber(numberToFormat)
  {
    String _formattedNumber;
    if (numberToFormat is int) {
      _formattedNumber = NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      ).format(numberToFormat);

      _formattedNumber = _formattedNumber.substring(0, _formattedNumber.length-1) +" "+
      _formattedNumber.substring(_formattedNumber.length-1, _formattedNumber.length);

    }
    else
      _formattedNumber = numberToFormat;

    return _formattedNumber;
  }


  static  Future<void> linkFbFromAllCamp(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account not verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Go to profile section and verify social media handles'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  static verifyYoutube(context) async{


    print("SS");
    _launchURL(context);

   }


   static   void _launchURL(BuildContext context) async {
       try {

         await launch(

           Variables.baseUrl + Variables.registerYoutube,
           option: new CustomTabsOption(
             headers: {
               'Content-Type': 'application/json; charset=UTF-8',
               'token' : Variables.token
             },
             toolbarColor: Theme.of(context).primaryColor,
             enableDefaultShare: true,
             enableUrlBarHiding: true,
             showPageTitle: true,
            // animation: new CustomTabsAnimation.fade(),
             // or user defined animation.

           extraCustomTabs: <String>[
             // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
             'org.mozilla.firefox',
             // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
             'com.microsoft.emmx',
           ],
         ),
       );
       } catch (e) {
       // An exception is thrown if browser app is not installed on Android device.
       debugPrint(e.toString());
       }
     }





  static openWebView() async{
    FlutterWebView flutterWebView = new FlutterWebView();


    print(Variables.token);
    print(        Variables.baseUrl + Variables.registerYoutube,
    );

    flutterWebView.launch(
        Variables.baseUrl + Variables.registerYoutube,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token' : Variables.token
        },
        javaScriptEnabled: true,
        toolbarActions: [
          new ToolbarAction("Dismiss", 1),
          new ToolbarAction("Reload", 2)
        ],
        inlineMediaEnabled: true,

        barColor: Colors.green,
        tintColor: Colors.white);
    flutterWebView.onToolbarAction.listen((identifier) {
      switch (identifier) {
        case 1:
          flutterWebView.dismiss();
          break;
        case 2:
          flutterWebView.load(
            "https://google.com",
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'token' : Variables.token
                          },
          );
          break;
      }
    });
    flutterWebView.listenForRedirect("mobile://test.com", true);


  }



}