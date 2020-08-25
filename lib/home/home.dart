import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,

      body: Text("SS"),

    );
  }
}

