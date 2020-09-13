import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketing/authentication/login.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:marketing/InfluencerHome//influencer_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Signup extends StatefulWidget {

  final int screen ;

  Signup( this.screen) ;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}







class _MyHomePageState extends State<Signup> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  String f_name = "";
  String s_name = "";
   String username = '';
  String password = "";
  bool isLoading = false;

  String type = "influencer";

  int screen = 0; //0 for email/phone and password. 1 for first name and last name.







  PanelController slideController = PanelController();
  TabController primaryTC;

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;





  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();

  }




  signUp() async {

    if (_formKey.currentState.validate()) {
      if(screen == 0)
        {
          sendVerificationCode();
          return;
        }
     }
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = 370;

    //MediaQuery.of(context).size.height * .80 < 370 ? ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: screen == 1?AppBar(
        leading: Functions.backButton(context),
      ): PreferredSize(
        child: Container(),
        preferredSize: Size(MediaQuery.of(context).size.width, 0),
      ),
      key: _scaffoldKey,

      body: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: 0,
        backdropTapClosesPanel: false,
        parallaxEnabled: true,
        controller: slideController,
        parallaxOffset: 0,
        backdropEnabled: true,
        body: _body(),
        panelBuilder: (sc) {
             return openBottomSheet(sc);
         },
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState(() {
          _fabHeight =
              pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }




  String hash = "";
  sendVerificationCode() async{

    print(slideController.isPanelClosed);
    try{
      if(!slideController.isPanelClosed) {
        isLoading = true;
      }
      else{
        isVerifyingOtp = true;
      }


      setState(() {

      });



      var res = await Functions.unsignPostReq(
          Variables.signUp_mail,
          jsonEncode({
            "username": username,
            "password": password,
            "access": type,
             "f_name" : s_name.split(" ")[0],
            "l_name" : s_name.split(" ")[1]!=null ? s_name.split(" ")[1]  : ""

          }));

      var s = jsonDecode(res.body);

      print(s);
      if(s["isError"])
        {
           Functions.showSnackBar(_scaffoldKey, s["message"]);

        }
      else{

        hash = s["key"];
        print(hash);
        slideController.open();

      }




      if(!slideController.isPanelClosed) {
        isLoading = false;
      }
      else{
        isVerifyingOtp = false;
      }
      setState(() {

      });
    }catch(e)
    {


      if(!slideController.isPanelClosed) {
        isLoading = false;
      }
      else{
        isVerifyingOtp = false;
      }
      setState(() {

      });
      Functions.showSnackBar(_scaffoldKey, Variables.connErrorMessage);
    }

  }


  _body(){
    return GestureDetector(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(left: 26, right: 26, top: 35),
                  child: Container(
                    //color: Colors.black12,
                    height: MediaQuery.of(context).size.height < 550
                        ? 550
                        : MediaQuery.of(context).size.height - 114,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

Spacer(flex: 1,),

                        Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: Variables.fontName,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: Variables.fontName,
                              fontWeight: FontWeight.w700),
                        ),
Spacer(),


                         TextFormField(
                           textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(

                              labelText: "Full Name",
                              labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                              contentPadding: EdgeInsets.only(left: 7, right: 7)
                            //fillColor: Colors.green

                          ),

                          onChanged: (s) {
                            s_name = s;
                          },
                          validator: (s) {
                            if (s.isEmpty) {
                              return "Enter a valid name";
                            }
                            if (s.length < 4)
                              return "Enter a valid name";
                            if(!s.trim().contains(" "))
                              {
                                return "Enter full name";

                              }
                            return null;
                          },
                        ),
                        Spacer(),

                         TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(

                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                              contentPadding: EdgeInsets.only(left: 7, right: 7)
                            //fillColor: Colors.green

                          ),

                          onChanged: (s) {
                            username = s;
                          },
                          validator: (s) {
                            if (s.isEmpty) {
                              return "Enter a valid email address";
                            }

                            String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                            RegExp regExp = new RegExp(p);

                            if(!regExp.hasMatch(s))
                              return "Enter a valid email address";


                            return null;
                          },
                        ),
                        Spacer(),

                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(

                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                              contentPadding: EdgeInsets.only(left: 7, right: 7)
                            //fillColor: Colors.green

                          ),

                          onChanged: (s) {
                            password = s;
                          },
                          validator: (s) {
                            if (s.isEmpty) {
                              return "Enter a valid password";
                            }
                            if (s.length < 5)
                              return "Password length is short";
                            return null;
                          },
                        ),

                        Spacer(flex: 2,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(),
                            Text(
                              "Sign Up", style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              fontFamily: Variables.fontName,
                            ),
                            ),
                            Spacer(),
                            Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          LocalColors.secondaryColor,
                                          LocalColors.secondaryColorGradient
                                        ],
                                        stops: [0, 0.7],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color:
                                            Color.fromRGBO(0, 0, 0, 0.2),
                                            blurRadius: 3.0,
                                            offset: Offset(-1, 1.75))
                                      ],
                                      borderRadius:
                                      BorderRadius.circular(50)),
                                  height: 65,
                                  width: 65,
                                ),
                                isLoading //&& !slideController.isPanelOpen
                                    ? Positioned(
                                  top: 20,
                                  left: 20.2,
                                  child: Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      new AlwaysStoppedAnimation<
                                          Color>(Colors.white),
                                    ),
                                    height: 25,
                                    width: 25,
                                  ),
                                )
                                    : Positioned(
                                  top: 7,
                                  left: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: 35,
                                      color:
                                      LocalColors.backgroundLight,
                                    ),
                                    onPressed: () {

                                      slideController.close();
                                      FocusScope.of(context)
                                          .requestFocus(
                                          new FocusNode());

                                      signUp();
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),

                        Container(height: 20,),
                        Spacer(flex: 5,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            FlatButton(
                              child:RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: LocalColors.textColorDark,
                                    fontSize: 14,
                                    fontFamily: Variables.fontName,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' Log In.', style: TextStyle(fontFamily: Variables.fontName, color: LocalColors.secondaryColor,
                                      fontSize: 16,)),
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.only(left: 5, right: 8),
                              onPressed: (){

                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login()));

                              },
                            ),


                          ],
                        ),


                        Container(height: 2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Functions.openWebView(Variables.privacyPolicyUrl, {});
                              },
                              child: Text("Privacy Policy",  style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                                decoration: TextDecoration.underline,

                                fontFamily: Variables.fontName,
                              ),),
                            )
                            ,
                            Text(" and ",  style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                              fontFamily: Variables.fontName,
                            ),)
                            ,GestureDetector(

                              onTap: (){
                                Functions.openWebView(Variables.termsConditionsUrl, {});
                              },
                              child: Text("T&C",  style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,    decoration: TextDecoration.underline,

                                fontFamily: Variables.fontName,
                              ),),
                            )
                            ,

                          ],
                        )

                      ],
                    ),
                  ))),
        ],
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }


String currentText = "";

 bool isVerifyingOtp = false;
  bool isOtpRight = true;

  StreamController<ErrorAnimationType> _errorController;
  TextEditingController textEditingController = TextEditingController();

  Widget openBottomSheet(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: <Widget>[
            ListView(
              physics: BouncingScrollPhysics(),

              controller: sc,
              children: <Widget>[


              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Spacer(),
                      isVerifyingOtp  ?  Padding(
                        padding: EdgeInsets.only(top: 20,right: 20),
                        child: Container(height: 20,width: 20,
                        child: CircularProgressIndicator(

                          strokeWidth: 1.5,
                          valueColor:
                          new AlwaysStoppedAnimation<
                              Color>(LocalColors.secondaryColor),
                        ),),
                      ) : IconButton(icon: Icon(Icons.close, color: LocalColors.secondaryColor,), onPressed: (){

                        slideController.close();

                      },)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40,right: 40,top: 30,bottom: 30),
                    child: PinCodeTextField(
                      textInputType: TextInputType.numberWithOptions(decimal: false, signed: false),
                      length: 4,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 200),
                      backgroundColor: Colors.white,
                      enableActiveFill: false,

                      errorAnimationController: _errorController,
                      controller: textEditingController,
                      onCompleted: (v) {

                        verifyOtp();
                      //  print(textEditingController.text);
                      },
                      onChanged: (value) {
                        //print(value);

                        if(!isOtpRight)
                          setState(() {
                            isOtpRight = true;
                          });

                         currentText = value;

                      },
                      beforeTextPaste: (text) {
                       // print("Allowing to paste $text");
                          return true;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),

                  FlatButton(
                    child:RichText(
                      text: TextSpan(
                        text: "Didn't Receive Mail? "  ,
                        style: TextStyle(
                          color: LocalColors.textColorLight,
                          fontSize: 14,
                          fontFamily: Variables.fontName,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: ' Resend', style: TextStyle(fontFamily: Variables.fontName, color: LocalColors.secondaryColor,
                            fontSize: 15,)),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5, right: 8),
                    onPressed: (){

                      signUp();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login()));

                    },
                  ),
                 !isOtpRight? Container(height: 18,): Container(),
                 !isOtpRight? Text(errorText, style: TextStyle(
                      color: Colors.red, fontFamily: Variables.fontName, fontSize: 16
                  ),):Container(height: 18,),

                  Container(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(left: 30,right: 30),
                    child: Container(
                      width: 250,
color: Colors.transparent,
                      height: 50,
                      child: RaisedButton(
                        padding: const EdgeInsets.only(left: 0,right: 0, top: 0,bottom: 0),

                        child: Container(
                          width: 250,height: 50,
                          child:Center(
                            child:  Text("Verify OTP", style: TextStyle(
                                color: Colors.white, fontFamily: Variables.fontName, fontSize: 16
                            )),
                          ),
                          decoration:   BoxDecoration(

                              gradient: LinearGradient(
                                colors: [
                                  LocalColors.secondaryColor,
                                  LocalColors.secondaryColorGradient
                                ],
                                stops: [0, 0.7],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(18.0))
                          )),



                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                         ),
                        color: Colors.transparent,

                        onPressed:isVerifyingOtp ? null : (){

                          verifyOtp();
                        },
                      ),
                    ),
                  )



                ],
              ),


              ],
            ),
          ],
        ));
  }


  @override
  void dispose() {
    _errorController.close();

    super.dispose();
  }



String errorText = "Invalid OTP";


  verifyOtp() async{

if(textEditingController.text.length !=4)
  {
    _errorController.add(ErrorAnimationType.shake);

    return;
  }



    try{
      isVerifyingOtp= true;
      setState(() {

      });



      var res = await Functions.unsignPostReq(
          Variables.signUp,
          jsonEncode({
            "otp": textEditingController.text,
            "username": username,
            "key" : hash,
            "password": password,
            "access": type,
            "f_name": s_name.split(" ")[0],
            "l_name": s_name.split(" ")[1] != null ? s_name.split(" ")[1] : s_name.split(" ")[1],
           }));




      var s = jsonDecode(res.body);

      print(s);
      if(s["isError"])
      {

        errorText = s["message"];
        _errorController.add(ErrorAnimationType.shake);
        isOtpRight = false;
        isVerifyingOtp = false;
        setState(() {});

      }
      else{

         isOtpRight = true;
        isVerifyingOtp = false;



         SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString(Variables.tokenString, s["token"]);
         prefs.setString(Variables.accessString, s["access"]);
         prefs.setString(
             Variables.firstNameString, Functions.capitalizeFirst(s["f_name"]));
         prefs.setString(Variables.lastNameString, s["l_name"]);
         prefs.setString(Variables.refreshTokenString, s["refresh"]);


         prefs.setInt(Variables.isFacebookString, 0);
         prefs.setInt(Variables.isYoutubeString, 0);
         prefs.setInt(Variables.isInstagramString, 0);

         Variables.token = s["token"];
         Variables.refreshToken = s["refresh"];
         Variables.firstName =
         s["f_name"] == null ? "" : Functions.capitalizeFirst(s["f_name"]);
         Variables.lastName = s["l_name"];
         Variables.access = s["access"];
         Variables.isYoutube = 0;
         Variables.isInstagram = 0;
         Variables.isFacebook = 0;
         setState(() {
         });
         if (s["access"] == "influencer") {

           Navigator.of(context).popUntil(ModalRoute.withName('/'));

           Navigator.pop(context);

           Navigator.push(context, MaterialPageRoute(builder: (context) =>  InfluencerMain()));
          // Navigator.pop(context);
           //Navigator.push(context,MaterialPageRoute(builder: (context) => InfluencerMain()));

         }

      }




      isLoading =false;
      setState(() {

      });
    }catch(e)
    {

      _errorController.add(ErrorAnimationType.shake);
      isOtpRight = false;
      isVerifyingOtp = false;
      setState(() {

      });
      Functions.showSnackBar(_scaffoldKey, Variables.connErrorMessage);
    }







  }
}









