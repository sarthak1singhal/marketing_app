import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyTransferIfAccNotSave extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MoneyTransferIfAccNotSave> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;


  String account_number = "";
  String ifsc_code = "";
  String name = "";
  String bank_name = "";
  String amount = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }




  getData(){
    setState(() {
      isLoading = true;
    });





    setState(() {
      isLoading = false;
    });
  }





  final _formKey = GlobalKey<FormState>();




  save(){

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(

        backgroundColor: LocalColors.backgroundLight,
        elevation: 1,
        leading: Functions.backButton(context),
        title: Text("Transfer Money"),

        actions: <Widget>[
          FlatButton(
            child: isLoading ? Container(height: 16,width: 16,child: CircularProgressIndicator(strokeWidth: 1.5,),):Text("SAVE"),
            disabledColor: LocalColors.backgroundLight,

            onPressed: isLoading ? null : (){

              save();

            },
          )
        ],
      ),
      key: _scaffoldKey,

      body:GestureDetector(
        child:  ListView(

          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(height: 30,),

            Padding(padding: EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 40),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,

                        initialValue: account_number,
                        decoration: InputDecoration(
                          labelText: "Account Number",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          account_number = s;
                        },
                        validator: (s){
                          if(s.isEmpty){
                            return "Enter a valid account number";
                          }
                          if(s.trim().length<8)
                            return "Enter a valid account number";
                          if(s.trim().contains(" ")){
                            return "Enter a valid account number";
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,

                      ),

                      Container(height: 24,),

                      TextFormField(
                        initialValue: ifsc_code,
                        decoration: InputDecoration(
                          labelText: "IFSC Code",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          ifsc_code = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isEmpty){
                            return "Enter a valid IFSC code";
                          }
                          if(s.trim().length<4)
                            return "Enter a valid IFSC code";
                          if(s.trim().contains(" ")){

                            return "Enter a valid IFSC code";
                          }
                          return null;
                        },

                      ),

                      Container(height: 24,),


                      TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          labelText: "Account Holder Name",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          name = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isEmpty){
                            return "Enter a valid name";
                          }
                          if(s.trim().length<3)
                            return "Enter a valid name";
                          if(s.trim().contains(" ")){

                            return "Enter a valid name";
                          }
                          return null;
                        },

                      ),




                      Container(height: 24,),


                      TextFormField(
                        initialValue: bank_name,
                        decoration: InputDecoration(
                          labelText: "Bank Name",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          bank_name = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isEmpty){
                            return "Enter a valid bank name";
                          }
                          if(s.trim().length<3)
                            return "Enter a valid bank name";
                          if(s.trim().contains(" ")){
                            return "Enter a valid bank name";
                          }
                          return null;
                        },

                      ),



                      Container(height: 24,),


                      TextFormField(
                        initialValue: amount,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          amount = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isEmpty){
                            return "Enter a valid amount";
                          }
                          if(s.trim().length<5)
                            return "Minimum amount that can be transferred is Rs. 10000";
                          if(s.trim().contains(" ")){
                            return "Enter a valid amount";
                          }

                          int n = int.tryParse(s) ?? 0;

                          if(n == 0)
                            {
                              return "Enter a valid amount";

                            }
                          if(n <10000)
                            return "Minimum amount that can be transferred is Rs. 10000";


                          return null;
                        },

                        keyboardType: TextInputType.number,

                      ),







                    ],

                  ),
                )

            )



          ],


        ),
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),


    );
  }



}
