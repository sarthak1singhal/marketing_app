import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'moneyTransferIfAccountNotSaved.dart';

class InfluencerWallet extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InfluencerWallet > {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String totalBalance = "343434";
  String currency = "Rs.";
  String ig_money  = "2323";
  String fb_money  = "2323";
  String yt_money  = "2323";
  String thisMonth  = "2323";
  String previousMonth  = "2323";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData(){

  }

  double width ;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(

      backgroundColor: LocalColors.backgroundLight,
      appBar: PreferredSize(
        child: Container(
        ),
        preferredSize: Size(
          width, 22
        ),
      ),
      body: SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          // onLoading: isLoading,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[

              Padding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Wallet",                   style: TextStyle(fontSize: 26,fontFamily: Variables.fontName, fontWeight: FontWeight.w700),
                    ),


Container(height: 30,),

balanceCard(),


                     Container(height: 25,),

                    buttons(),



                    Container(height: 20,),

                  ],
                ),
                padding: EdgeInsets.only(left: 22,right: 22,top: 14),
              ),
              Column(
                  children: <Widget>[
                    socialMediaCards(),




                    Container(height: 20,),


Padding(

    child:                                         middleCards(),

  padding: EdgeInsets.only(left: 22,right: 22,top: 0),
)

                  ],
                ),

















              




            ],
          )),


      key: _scaffoldKey,


    );
  }




  balanceCard(){
    return
      Stack(
        children: <Widget>[
          Container(
            width: width,
            height: 140,
            decoration: BoxDecoration(
                color: LocalColors.secondaryColor,
                gradient: LinearGradient(
                  colors: [LocalColors.secondaryColor,Colors.blue],
                  stops: [0,0.7],
                ),
                boxShadow: [
                  BoxShadow(
                      color:  Color.fromRGBO(0, 0, 0, 0.27),
                      blurRadius:8.0,
                      spreadRadius: 0.5,
                      offset: Offset(-2,3),


                  ),

                ],
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
          ),
          Positioned(top: 35,left: 30,
          child: Text("Total Balance", style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontFamily: Variables.fontName
          ),),
          ),


          Positioned(top: 60,left: 30,
            child: Text(currency + " "+totalBalance, style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: Variables.fontName,
              fontWeight: FontWeight.w500
            ),),
          ),

          Positioned(top: 20,right: 30,child: Icon(Icons.attach_money, size: 80, color: Colors.white38,),),
          Positioned(top: 39.86,right: 56,child: Icon(Icons.attach_money, size: 80, color: Colors.white38,),)
        ],
      );
  }


  buttons(){
    double w = (width-44 - 20)/2;

    return(

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        getButton(w, true, LocalColors.backgroundLight, LocalColors.secondaryColor, Icons.attach_money, (){

          sendMoney();

        }, "Send money", 6.3,17.5),
        getButton(w, true, LocalColors.backgroundLight, LocalColors.secondaryColor, Icons.history, (){}, "View Activity", 4.9, 17.5),

    //    getButton(w, false, LocalColors.secondaryColor, LocalColors.backgroundLight, Icons.history, (){}, "View Activity", 4.9, 17.5)

      ],
    )

    );
  }







  getButton(double w,bool isBorder, Color mainColor, Color secondaryColor, IconData icon, Function onPressed, buttonText, double topIconRight, double topIconTop)
  {
    return
        Container(
          width : w,
          height: 94,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side:isBorder ?  BorderSide(width:2,color: secondaryColor) : BorderSide(width:0,color: mainColor) ,


            ),
            color: mainColor,
            //  color: LocalColors.backgroundLight,

            child: Stack(

              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 12,
                  child: Container(height: 35,width: 35,decoration: BoxDecoration(
                    //color:LocalColors.secondaryColor,
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(30)

                  ),


                  ),
                ),Positioned(
                  left: topIconRight,
                  top: topIconTop,
                  child: Icon(icon,
                    //  color: LocalColors.backgroundLight,
                    color: mainColor,



                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 0,
                  child: Text(buttonText, style: TextStyle(
                      color: secondaryColor
                    // color: LocalColors.secondaryColor
                  ),),
                ),
                Positioned(
                  bottom: 9,
                  right: 0,
                  child: Icon(Icons.navigate_next,
                    //color: LocalColors.secondaryColor
                    color: secondaryColor
                    ,),
                )
              ],
            ),



            onPressed: onPressed,
          ),
        );

  }











  socialMediaCards(){

    BoxDecoration decoration = BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(

            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 15.0,
            offset: Offset(0,4)
        )],
        borderRadius: BorderRadius.all(Radius.circular(16))
);

    double w = (width- 80)/3.0;

    List<Widget> cards = [];
    cards.add(socialMediaSingleCard(w, Colors.pink, Color.fromRGBO(0,0, 0, 0.15), MaterialCommunityIcons.instagram, currency + " " +ig_money));
    cards.add(socialMediaSingleCard(w, Colors.blue, Color.fromRGBO(0,0, 0, 0.15), MaterialCommunityIcons.facebook, currency + " " +fb_money));
    cards.add(socialMediaSingleCard(w, Colors.red, Color.fromRGBO(0,0, 0, 0.15), MaterialCommunityIcons.youtube, currency + " " +yt_money));

    return GridView.extent(
      physics: ScrollPhysics(),
      maxCrossAxisExtent: 180,
      padding: EdgeInsets.only(left: 12,right: 12),
      shrinkWrap: true,
      children: cards,
      childAspectRatio: 1,
    );



  }




  socialMediaSingleCard(double w, Color color, Color shadowColor, IconData icon, String amt){
    return   Stack(
      children: <Widget>[
        Padding(
          child: Container(
          //  height: w,
         //   width: w,
            decoration: BoxDecoration(
                color: LocalColors.backgroundLight,
        border: Border.all(width:2,color: color),

        boxShadow: [

                  BoxShadow(


                    color: shadowColor,// Color.fromRGBO(0, 0, 0, 0.17),
                    blurRadius:6.0,
                    offset: Offset(-2,3)
                )],
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
          ),
          padding: EdgeInsets.only(left: 10,right: 10, top: 10,bottom: 10),
        ),
        Positioned(
          top: 7.3,
          right:7.3,child: Container(
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,

          ),
          height: 50,width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
          //    color: Colors.white24

            color: color
          ),
        ),
        ),
        Positioned(
          bottom: 37,
          left: 26,
          child:   Text(amt, style: TextStyle(
              fontSize: 14,
              fontFamily: Variables.fontName,
          color: color
            //    color: Colors.white70
          ),)
          ,
        )
      ],
    );
  }

















  middleCards(){

    double w = (width- 44) /2.0;


    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
          boxShadow: [
            BoxShadow(
              //offset: Offset(0, 70),

              offset: Offset(0,3),
              //spreadRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius:5.0),

          ],
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          middleContainer(w, Colors.lightBlueAccent, "This Month", currency + " "+ thisMonth),



          middleContainer(w, Colors.red, "Previous Month", currency + " "+ previousMonth)












        ],
      ),
    );
  }



  Widget middleContainer(double w, Color color, String titleText, String amount){
    return           Container(
      width: w,
      height: 100,
      child: Row(
        children: <Widget>[Padding(
          padding: EdgeInsets.all(18),
          child: Container(
            height: 12, width: 12,
            decoration: BoxDecoration(

                color: color,
                borderRadius: BorderRadius.all(Radius.circular((10)))
            ),
          ),
        ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(titleText, style: TextStyle(
                    color: Colors.black45,
                    fontFamily: Variables.fontName
                ),),
              ),
              Container(height: 8,),
              Text(amount, style: TextStyle(fontFamily: Variables.fontName,fontWeight: FontWeight.w700,color: Colors.black87, fontSize: 21),)

            ],
          )


        ],
      ),

    );

  }







  RefreshController _refreshController = RefreshController(initialRefresh: false);




  void _onRefresh() async {
    // monitor network fetch
    await getData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {});
  }






  sendMoney() async{

    var h = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoneyTransferIfAccNotSave()),
    );
    getData();
    setState(() {

    });
  }





}
