import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketing/authentication/login.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/variables.dart';
 import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/signup.dart';
import 'InfluencerHome/influencer_main.dart';

void main() {


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor: Colors.white, //bottom bar color

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
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => StartApp(),
          '/login': (context) => Login(),
          '/signup': (context) => Signup(0)
          // When navigating to the "/second" route, build the SecondScreen widget.
          //'/second': (context) => SecondScreen(),
        },
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
     //  home: StartApp()
    );
  }



}






class StartApp extends StatefulWidget {


  @override
  StartAppState createState() => StartAppState();
}

class StartAppState extends State<StartApp> {


  //if loading, then 0. if signup then loading = 1, if influencer then loading = 2. if client then loading = 3
  int loading = 0;


  @override
  void initState() {
    super.initState();
    getWindow();
  }

  getWindow () async{

    loading = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Variables.token = prefs.getString(Variables.tokenString);
    Variables.refreshToken = prefs.getString(Variables.refreshTokenString);
    Variables.access = prefs.getString(Variables.accessString) ;
    Variables.firstName = prefs.getString(Variables.firstNameString) == null ? "" : prefs.getString(Variables.firstNameString) ;
    Variables.lastName = prefs.getString(Variables.lastNameString) == null ? "" : prefs.getString(Variables.lastNameString) ;




    if(Variables.token !=null)
      {
        if(Variables.access == "influencer")
          {
            loading = 2;


            Variables.isFacebook = prefs.getInt(Variables.isFacebookString);
            Variables.isInstagram = prefs.getInt(Variables.isInstagramString);
            Variables.isYoutube = prefs.getInt(Variables.isYoutubeString);


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

        body: loading == 0 ? Center(): loading == 1 ? Login() : InfluencerMain(),

    );
  }
}
