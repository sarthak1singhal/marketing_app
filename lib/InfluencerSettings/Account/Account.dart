import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/InfluencerSettings/settings.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChangePassword.dart';

class Account extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Account> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: LocalColors.backgroundLight,

        leading: Functions.backButton(context),
        elevation: 0,
        title: Text("Account", style: TextStyle(fontFamily: Variables.fontName),),
      ),
      key: _scaffoldKey,

      body: ListView(


        children: <Widget>[
          ListTile(
            title: Text("Change Password"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword()),
              );
            },

          ),
          ListTile(
            title: Text("Privacy Policy"),

          ),
          ListTile(
            title: Text("Terms and Conditions"),

          ),

        ],

      ),

    );
  }
}
