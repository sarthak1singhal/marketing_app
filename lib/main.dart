import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/variables.dart';
import 'package:marketing/home/homeParent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/signup.dart';
import 'home/influencer_main.dart';

void main() {


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: LocalColors.backgroundLight, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor: LocalColors.backgroundLight, //bottom bar color

    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,

      title: 'Flutter Demo',
      theme: ThemeData(

          primaryColor: Colors.white,
          accentColor: Colors.redAccent,
          hintColor: Colors.black87,
          primaryColorDark: Colors.red,
          backgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            labelStyle: TextStyle(color: Colors.black45),
          )
      ),
      home: StartApp()
    );
  }



}






class StartApp extends StatefulWidget {


  @override
  StartAppState createState() => StartAppState();
}

class StartAppState extends State<StartApp> {


  //if loading, then 0. if signup, then loading = 1, if influencer, then loading = 2. if client then loading = 3
  int loading = 0;


  @override
  void initState() {
    getWindow();
  }

  getWindow () async{

    loading = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Variables.token = prefs.getString(Variables.tokenString);
    Variables.access = prefs.getString(Variables.accessString) ;
    Variables.firstName = prefs.getString(Variables.firstNameString) == null ? "" : prefs.getString(Variables.firstNameString) ;
    Variables.lastName = prefs.getString(Variables.lastNameString) == null ? "" : prefs.getString(Variables.lastNameString) ;

    if(Variables.token !=null)
      {
        if(Variables.access == "influencer")
          {
            loading = 2;
          }
      }
    else{
      loading = 1;
    }

    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: loading == 0 ? Center(): loading == 1 ? Signup() : InfluencerMain(),

    );
  }
}
