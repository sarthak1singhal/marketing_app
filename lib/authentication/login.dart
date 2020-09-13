import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketing/authentication/signup.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:marketing/InfluencerHome//influencer_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {

  final String ScreenPopmessage;

  const Login({Key key, this.ScreenPopmessage}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState(){
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons

     ));

    if(widget.ScreenPopmessage != null)
      {

        if(widget.ScreenPopmessage.trim()!="")
          {

            Functions.showSnackBar(_scaffoldKey, widget.ScreenPopmessage);

          }

      }

  }

  @override
  dispose(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: LocalColors.backgroundLight, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons

    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();


  String username = '';
  String password = "";
  String type = "influencer";

  bool isLoading = false;


  signIn() async{

    if(_formKey.currentState.validate())
    {
      isLoading = true;

      setState(() {

      });
      try{


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

            Functions.showSnackBar(_scaffoldKey, s["message"].toString());
          }
        }else{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(Variables.tokenString, s["token"]);
          prefs.setString(Variables.accessString, s["access"]);
          prefs.setString(Variables.firstNameString, capitalizeFirst(s["f_name"]));
          prefs.setString(Variables.lastNameString, s["l_name"]);
          prefs.setString(Variables.refreshTokenString, s["refresh"]);

          prefs.setInt(Variables.isFacebookString, s["isFacebook"]);
          prefs.setInt(Variables.isYoutubeString, s["isYoutube"]);
          prefs.setInt(Variables.isInstagramString, s["isInstagram"]);

          Variables.token = s["token"];
          Variables.firstName = s["f_name"]  == null ? "" : capitalizeFirst(s["f_name"]);
          Variables.lastName = s["l_name"];
          Variables.access = s["access"];
          Variables.refreshToken = s["refresh"];

          Variables.isYoutube = s["isYoutube"];
          Variables.isInstagram = s["isInstagram"];
          Variables.isFacebook = s["isFacebook"];

          if(s["access"] == "influencer")
          {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));

          //  Navigator.pop(context);

            Navigator.push(context, MaterialPageRoute(builder: (context) =>  InfluencerMain()));
          }
        }




        isLoading = false;
        setState(() {

        });







      }catch(e)
    {
      debugPrint(e);
      isLoading = false;
      Functions.showSnackBar(_scaffoldKey, "Some connection error occured");
      setState(() {

      });
    }



    }


  }



  @override
  Widget build(BuildContext context) {

      return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: PreferredSize(
        child: Container(
      /*      child: ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      //height: 15,
                      color: Colors.transparent,
                    )))
*/
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 30),
      ),
      key: _scaffoldKey,

      body:        GestureDetector(
        child:    ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Form(
              key: _formKey,
              child:Padding(
                padding: EdgeInsets.only(left: 26,right: 26,top: 35),
                child: Container(
                  //color: Colors.black12,
                  height: MediaQuery.of(context).size.height < 500 ? 500 : MediaQuery.of(context).size.height  - 140,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Text("Welcome", style: TextStyle(fontSize: 32, fontFamily: Variables.fontName, fontWeight: FontWeight.w700),),
                      Text("Back!", style: TextStyle(fontSize: 32, fontFamily: Variables.fontName, fontWeight: FontWeight.w700),),

                      Container(height: 60,),

                      TextFormField(
                        decoration: InputDecoration(

                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                            contentPadding: EdgeInsets.only(left: 7, right: 7)
                          //fillColor: Colors.green

                        ),
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

                      Container(height: 30,)
                      ,
                      TextFormField(


                        obscureText: true,
                        decoration: InputDecoration(

                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                            contentPadding: EdgeInsets.only(left: 7, right: 7)
                          //fillColor: Colors.green

                        ),

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



                      Container(height: 50,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Sign in", style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            fontFamily: Variables.fontName,
                          ),
                          ),
                          //Spacer(),
                          Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [LocalColors.secondaryColor,LocalColors.secondaryColorGradient],
                                      stops: [0,0.7],
                                    ),                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius : 1,
                                          color: Color.fromRGBO(0, 0, 0, 0.2),
                                          blurRadius: 3.0,
                                          offset: Offset(-1,1.75)
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                height: 65,width: 65,
                              ),
                          isLoading?

                          Positioned(top: 20, left: 20.2,child: Container(
                            child: CircularProgressIndicator( strokeWidth: 2, valueColor: new AlwaysStoppedAnimation<Color>(Colors.white), ),
                            height: 25,
                            width: 25,
                          ),):


                          Positioned(top: 7,left: 8,child:


                              IconButton(

                                icon: Icon(Icons.arrow_forward, size: 35, color: LocalColors.backgroundLight, ),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(new FocusNode());

                                  signIn();
                                },
                              ),)
                            ],
                          )
                        ],
                      ),

                      FlatButton(
                        padding: EdgeInsets.only(left: 0, right: 5),
                        child: Text("Forgot Password?", style: TextStyle(
                          fontSize: 15,
                          fontFamily: Variables.fontName,
                          decoration: TextDecoration.underline,

                        ),),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        },
                      ),
                      Spacer(),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          FlatButton(
                            child:RichText(
                              text: TextSpan(
                                text: 'Dont have an account? ',
                                style: TextStyle(
 color: LocalColors.textColorDark,
                                  fontSize: 14,
                                  fontFamily: Variables.fontName,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: ' Sign Up.', style: TextStyle(fontFamily: Variables.fontName, color: LocalColors.secondaryColor,
                                    fontSize: 16,)),
                                ],
                              ),
                            ),
                          padding: EdgeInsets.only(left: 5, right: 8),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  Signup(0)));

                            },
                          ),


                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),

          ],
        )
        ,
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());


        },
      ),
    );
  }



  String capitalizeFirst(String s) {
    if(s.length>1)
      return s[0].toUpperCase() + s.substring(1);

    return s;
  }
}
