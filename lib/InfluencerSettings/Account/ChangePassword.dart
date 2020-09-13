import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/CustomWidgets.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';

class ChangePassword extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String currentPassword ="";
  String _newPass="";
  String confirmNewPass ="";
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  
  
  save() async {
    if (_formKey.currentState.validate()) {
      isLoading = true;
      setState(() {

      });


      try {
        var res = await Functions.postReq(
            Variables.changePassword, json.encode({
          "password": currentPassword,
          "new_password": _newPass,
          "confirm_password": confirmNewPass,
          "platform": "app"
        }), context);

        var s = jsonDecode(res.body);

        print(s);
        if (s["isError"]) {
          Functions.showSnackBar(_scaffoldKey, s["message"]);
          isLoading = false;

          setState(() {});
        } else {
          Functions.showSnackBar(_scaffoldKey, s["message"]);
        }
      }
      catch (e) {
        Functions.showSnackBar(_scaffoldKey, "Some error occured");
      }


      isLoading = false;
      setState(() {

      });
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(

        backgroundColor: LocalColors.backgroundLight,

        actions: <Widget>[
          CustomWidgets.loadingFlatButton(isLoading, (){save();})

        ],
        leading: Functions.backButton(context),
        elevation: 1,
        title: Text("Change Password", style: TextStyle(fontFamily: Variables.fontName, fontWeight: FontWeight.w600),),
      ),
      key: _scaffoldKey,

      body: ListView(
physics: BouncingScrollPhysics(),

        children: <Widget>[
          Form(
              key: _formKey,
         child:
         Padding(
           padding: EdgeInsets.only(left: 21,right: 21, top: 30),
           child: Column(children: <Widget>[
             TextFormField(
               obscureText: true,
               decoration: InputDecoration(

                   labelText: "Current Password",
                   labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName ),

                   contentPadding: EdgeInsets.only(left: 7, right: 7)
                 //fillColor: Colors.green

               ),

               onChanged: (s) {
                 currentPassword = s;
               },
               validator: (s) {
                 if (s.isEmpty) {
                   return "Enter a valid password";
                 }
                 if (s.length < 7)
                   return "Password length is short";
                 return null;
               },
             ),
             
             Container(height: 30,),


             TextFormField(
               obscureText: true,
               decoration: InputDecoration(

                   labelText: "New Password",
                   labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                   contentPadding: EdgeInsets.only(left: 7, right: 7)
                 //fillColor: Colors.green

               ),

               onChanged: (s) {
                 _newPass = s;
               },
               validator: (s) {
                 if (s.isEmpty) {
                   return "Enter a valid password";
                 }
                 if (s.length < 8)
                   return "Password length is short";
                 return null;
               },
             ),

             Container(height: 30,),


             TextFormField(
               obscureText: true,
               decoration: InputDecoration(

                   labelText: "Confirm New Password",
                   labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                   contentPadding: EdgeInsets.only(left: 7, right: 7)
                 //fillColor: Colors.green

               ),

               onChanged: (s) {
                 confirmNewPass = s;
               },
               validator: (s) {
                 if (s.isEmpty) {
                   return "Enter a valid password";
                 }
                 if (s!=_newPass)
                   return "Passwords do not match";
                 return null;
               },
             ),


           ],),
         )
    )
        ],

      ),

    );
  }
  
  
  
}
