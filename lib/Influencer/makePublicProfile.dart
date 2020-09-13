import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfileVisibility extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChangeProfileVisibility> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool isLoading = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: LocalColors.backgroundLight,

        elevation: 1,
        leading: Functions.backButton(context),
        title: Text("Public Settings"),
      ),
      key: _scaffoldKey,
      body: isLoading ? Functions.showLoader() :

          Padding(
            child: Column(
              children: <Widget>[

                

              ],
            ),
            padding: EdgeInsets.only(left: 21,right: 21,top: 30),
          )
      ,


    );
  }
}
