import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Account/Account.dart';

class InfluencerSettings extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InfluencerSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: LocalColors.backgroundLight,

        leading: Functions.backButton(context),
        elevation: 0,
        title: Text("Settings", style: TextStyle(fontFamily: Variables.fontName),),
      ),
      key: _scaffoldKey,

body: ListView(


  children: <Widget>[
    ListTile(
      title: Text("Account"),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Account()),
        );
      },

    ),
    ListTile(
      title: Text("Privacy Policy"),
      onTap: (){
        Functions.openWebView(Variables.privacyPolicyUrl, {});
      },

    ),
    ListTile(
      title: Text("Terms and Conditions"),
      onTap: (){
        Functions.openWebView(Variables.termsConditionsUrl, {});
      },

    ),    ListTile(
      title: Text("Logout"),
      onTap: (){
        Functions.openWebView(Variables.termsConditionsUrl, {});
      },

    ),

  ],

),

    );
  }
}
