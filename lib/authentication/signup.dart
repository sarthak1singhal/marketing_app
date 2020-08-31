import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:marketing/InfluencerHome//influencer_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  String f_name = "";
  String s_name = "";
  String password_confirmation = "";
  String username = '';
  String password = "";
  String type = "influencer";
  signUp() async{

    if(_formKey.currentState.validate()){

      print(f_name);
     var res = await  Functions.unsignPostReq(Variables.signUp, jsonEncode({
       "username" : username,
       "password": password,
       "access" : type,
       "f_name" : f_name,
       "l_name" : s_name,
       "password_confirmation" : password_confirmation
     }));

     var s = jsonDecode(res.body);
     print(s);


     if(s["isError"])
     {
       if(s["message"]!=null){

         _scaffoldKey.currentState.showSnackBar(SnackBar(
           content: Text(s["message"]),
         ));
         }
     }else{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString(Variables.tokenString, s["token"]);
       prefs.setString(Variables.accessString, s["access"]);
       prefs.setString(Variables.firstNameString, capitalizeFirst(s["f_name"]));
       prefs.setString(Variables.lastNameString, s["l_name"]);
       prefs.setInt(Variables.isFacebookString,0);
       prefs.setInt(Variables.isYoutubeString, 0);
       prefs.setInt(Variables.isInstagramString, 0);



       Variables.token = s["token"];
       Variables.firstName = s["f_name"] == null ? "" : capitalizeFirst(s["f_name"]);
       Variables.lastName = s["l_name"];
       Variables.access = s["access"];
       Variables.isYoutube = 0;
       Variables.isInstagram = 0;
       Variables.isFacebook = 0;

       if(s["access"] == "influencer")
       {
         Navigator.pop(context);
         Navigator.push(
             context, MaterialPageRoute(builder: (context) =>  InfluencerMain()));
       }
     }

     print(res.statusCode);
    }


  }



  signIn() async{


      var res = await  Functions.unsignPostReq(Variables.signIn, jsonEncode({
        "username" : username,
        "password": password,
        "access" : type,
      }));

      var s = jsonDecode(res.body);
      print(s);


      if(s["isError"])
      {
        if(s["message"]!=null){

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(s["message"]),
          ));
        }
      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(Variables.tokenString, s["token"]);
        prefs.setString(Variables.accessString, s["access"]);
        prefs.setString(Variables.firstNameString, capitalizeFirst(s["f_name"]));
        prefs.setString(Variables.lastNameString, s["l_name"]);

        prefs.setInt(Variables.isFacebookString, s["isFacebook"]);
        prefs.setInt(Variables.isYoutubeString, s["isYoutube"]);
        prefs.setInt(Variables.isInstagramString, s["isInstagram"]);

        Variables.token = s["token"];
        Variables.firstName = s["f_name"]  == null ? "" : capitalizeFirst(s["f_name"]);
        Variables.lastName = s["l_name"];
        Variables.access = s["access"];

        Variables.isYoutube = s["isYoutube"];
        Variables.isInstagram = s["isInstagram"];
        Variables.isFacebook = s["isFacebook"];

        if(s["access"] == "influencer")
        {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>  InfluencerMain()));
        }

      }

      print(res.statusCode);


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Signup"),
      ),
      key: _scaffoldKey,

      body: Center(

        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                onChanged: (s){
                  f_name = s;
                },
                validator: (s){
                  if(s.isEmpty){
                    return "Enter a valid name";
                  }
                  if(s.length<3)
                    return "Enter a valid name";
                  return null;
                },

              ),
              TextFormField(
                onChanged: (s){
                  s_name = s;
                },
                validator: (s){
                  if(s.isEmpty){
                    return "Enter a valid last name";
                  }
                  if(s.length<3)
                    return "Enter a valid last name";
                  return null;
                },

              ),





              TextFormField(
                onChanged: (s){
                  username = s;
                },
                validator: (s){
                  if(s.isEmpty){
                    return "Enter a valid username";
                  }
                  if(s.length<7)
                    return "Enter a valid username";
                  return null;
                },

              ),

              TextFormField(
                onChanged: (s){
                  password = s;
                },
                validator: (s){
                  if(s.isEmpty){
                    return "Enter a valid password";
                  }
                  if(s.length<5)
                    return "Password length is short";
                  return null;
                },
              ),



              TextFormField(
                onChanged: (s){
                  password_confirmation = s;
                },
                validator: (s){
                  if(s.isEmpty){
                    return "Confirm the password";
                  }
                  if(s!=password)
                    {
                      return "Passwords do not match";
                    }

                  return null;
                },
              ),

              RaisedButton (
                child: Text("Signup"),
                onPressed: (){
                  signUp();
                },
              ),

              RaisedButton (
                child: Text("Sign in"),
                onPressed: (){
                  signIn();
                },
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  String capitalizeFirst(String s) {
   if(s.length>1)
    return s[0].toUpperCase() + s.substring(1);

   return s;
  }
}
