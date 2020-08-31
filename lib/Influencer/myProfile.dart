import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {




  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Profile> with  AutomaticKeepAliveClientMixin<Profile>  {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  bool isInternet = true;

  bool isLoading = true;

  dynamic data = {};

  bool error = false;

  Future<bool> getData() async{

    try {
      var res = await Functions.postReq(Variables.getProfile, "");


      data = jsonDecode(res.body);

      data = data["data"];
      data["social"]["instagram_followers"] = 403003300;
      data["social"]["facebook_page_likes"] = 4000;
      data["social"]["youtube_subscribers"] = 4000000;
      data["social"]["facebook_id"] = "sarthak1singhalwfnfwfnmm";
      data["social"]["youtube_channel_name"] = "sarthak1singhal";
      data["social"]["instagram_id"] = "sarthak1singhal";
print(data);

      isLoading = false;
      setState(() {

      });

      return true;

    }catch(e){
      print(e.toString());
      setState(() {
        error = true;
        isLoading  = false;
      });

      return true;
    }
 
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await getData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {

    });
  }

  double height ;
  double width;

  @override
  Widget build(BuildContext context) {
    height =MediaQuery.of(context).size.height - 200;
width =MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
appBar: PreferredSize(child: Container(),
preferredSize: Size(width,22),
),
      key: _scaffoldKey,

      body: SmartRefresher(

          enablePullDown: true,
          header: 		ClassicHeader(),

                controller: _refreshController,
                onRefresh: _onRefresh,
                // onLoading: isLoading,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[

                    header(),
                    isLoading ? Container(
                      child: Center(
                        child: Functions.showLoader(),
                      ),
                      width: width,
                      height: height,
                    ): getCards(MediaQuery.of(context).size.height, width)
                  ],
                )
            )




    );
  }




  Widget getCards(height, width){



  List<Widget> cards  = [];


    cards.add( Stack(
      children: <Widget>[
      Padding(
        child:   GestureDetector(
      child: Container(
      decoration: BoxDecoration(
      color: Colors.pink,


      boxShadow: [BoxShadow(
          color: Color.fromRGBO(224, 20, 90, 0.20),
          blurRadius: 17.0
      )],
      borderRadius: BorderRadius.all(Radius.circular(16))
  ),
  ),
  ),
        padding: EdgeInsets.all(14),
      ),

        Positioned(top: 10,right: 10,
          child: Container(

            child: Icon( MaterialCommunityIcons
                .instagram, color: Colors.white, size: 34,),
            height: 68,
            width: 68,
            decoration: BoxDecoration(

                color: Colors.white24,
                borderRadius: BorderRadius.only(topRight: Radius.circular(82),topLeft: Radius.circular(90), bottomLeft: Radius.circular(90), bottomRight: Radius.circular(90))
            ),
          ),
        ),

        Functions.isNullEmptyOrFalse(data["social"]["instagram_followers"] )? Positioned(
          left: 40,
          bottom: 40,
          child: Text("Verify", style: TextStyle(color: Colors.white, fontSize: 18),),
        ):
            Positioned(
              left: 40,
              bottom: 75,
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Text(Functions.getRedableNumber(data["social"]["instagram_followers"] ).split(" ")[0], style: TextStyle(
                      color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600
                  ),),

                  Container(width: 6,),
                  Text(Functions.getRedableNumber(data["social"]["instagram_followers"] ).split(" ")[1], style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600
                  ),),
                ],
              )
            ),

        Functions.isNullEmptyOrFalse(data["social"]["instagram_id"])? Container():
        Positioned(
          bottom: 30,right: 30,
          child: Text(data["social"]["instagram_id"].length>19 ? "@"+data["social"]["instagram_id"].substring(0,19)
              :"@"+data["social"]["instagram_id"]
            , style: TextStyle(fontSize:13,color: Colors.white60, ),),
        )


      ],
    ),
    );




    cards.add( Stack(
      children: <Widget>[
        Padding(
          child:   GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,


                  boxShadow: [BoxShadow(
                      color: Color.fromRGBO(33, 150,243, 0.25),
                      blurRadius:15
                  )],
                  borderRadius: BorderRadius.all(Radius.circular(16))
              ),
            ),
          ),
          padding: EdgeInsets.all(14),
        ),

        Positioned(top: 10,right: 10,
          child: Container(

            child: Icon( MaterialCommunityIcons
                .facebook, color: Colors.white, size: 34,),
            height: 68,
            width: 68,
            decoration: BoxDecoration(

                color: Colors.white24,
                borderRadius: BorderRadius.only(topRight: Radius.circular(52),topLeft: Radius.circular(90), bottomLeft: Radius.circular(90), bottomRight: Radius.circular(90))
            ),
          ),
        ),

        Functions.isNullEmptyOrFalse(data["social"]["facebook_page_likes"] )? Positioned(
          left: 40,
          bottom: 40,
          child: Text("Verify", style: TextStyle(color: Colors.white, fontSize: 18),),
        ):
        Positioned(
            left: 40,
            bottom: 75,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: <Widget>[
                Text(Functions.getRedableNumber(data["social"]["facebook_page_likes"] ).split(" ")[0], style: TextStyle(
                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600
                ),),

                Container(width: 6,),
                Text(Functions.getRedableNumber(data["social"]["facebook_page_likes"] ).split(" ")[1], style: TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600
                ),),
              ],
            )
        ),



        Functions.isNullEmptyOrFalse(data["social"]["facebook_id"])? Container():
        Positioned(
          bottom: 30,right: 30,
          child: Text(data["social"]["facebook_id"].length>19 ? "@"+data["social"]["facebook_id"].substring(0,19)
            :"@"+data["social"]["facebook_id"]
            , style: TextStyle(fontSize:13,color: Colors.white60, ),),
        )




      ],
    ),
    );



   cards.add( Stack(
      children: <Widget>[
        Padding(
          child:   GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,


                  boxShadow: [BoxShadow(
                      color: Color.fromRGBO(244, 66,54, 0.25),
                      blurRadius:15
                  )],
                  borderRadius: BorderRadius.all(Radius.circular(16))
              ),
            ),
          onTap: (){


Functions.verifyYoutube(context);



          },
          ),

          padding: EdgeInsets.all(14),
        ),

        Positioned(top: 10,right: 10,
          child: Container(

            child: Icon( MaterialCommunityIcons
                .youtube, color: Colors.white, size: 34,),
            height: 68,
            width: 68,
            decoration: BoxDecoration(

                color: Colors.white24,
                borderRadius: BorderRadius.only(topRight: Radius.circular(52),topLeft: Radius.circular(90), bottomLeft: Radius.circular(90), bottomRight: Radius.circular(90))
            ),
          ),
        ),
        Functions.isNullEmptyOrFalse(data["social"]["youtube_subscribers"] )? Positioned(
          left: 40,
          bottom: 40,
          child: Text("Verify", style: TextStyle(color: Colors.white, fontSize: 18),),
        ):
        Positioned(
            left: 40,
            bottom: 75,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: <Widget>[
                Text(Functions.getRedableNumber(data["social"]["youtube_subscribers"] ).split(" ")[0], style: TextStyle(
                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600
                ),),

                Container(width: 6,),
                Text(Functions.getRedableNumber(data["social"]["youtube_subscribers"] ).split(" ")[1], style: TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600
                ),),
              ],
            )
        ),
        Functions.isNullEmptyOrFalse(data["social"]["youtube_channel_name"])? Container():
        Positioned(
          bottom: 30,right: 30,
          child: Text(data["social"]["youtube_channel_name"].length>19 ? "@"+data["social"]["youtube_channel_name"].substring(0,19)
              :"@"+data["social"]["youtube_channel_name"]
            , style: TextStyle(fontSize:13,color: Colors.white60, ),),
        )
      ],
    ),
    );



    return (GridView.extent(
      physics: ScrollPhysics(),
      maxCrossAxisExtent: 280,
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      children: cards,
      childAspectRatio: 1,
    ));
  }




  Widget header(){

    return Padding(
      padding: EdgeInsets.only(left: 26,right: 26,top: 8,bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //textBaseline: TextBaseline.,
        children: <Widget>[
          Variables.profile_image == ""?
          Container(
            height: 55,
            child: Icon( Icons.person, color: Colors.white60,),
            decoration: BoxDecoration(
                color: Colors.black12,

                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            width: 55,
          ):
          Container(
            height: 55,
            decoration: BoxDecoration(
                color: Colors.red,

                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            width: 55,
          ),
          Container(width: 14,),
        GestureDetector(
          child:   Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(Variables.firstName, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700), ),
              Container(height: 4,),
              Text("Edit Profile"),
              Container(height: 5,),
            ],
          ),
          onTap: (editProfilePage()),
        ),

          Spacer(),

          Column(
            children: <Widget>[

              IconButton(icon: Icon(Icons.settings, color: Colors.black54,),onPressed: (){

              },),
              Container(height: 14,)
            ],
          )
        ],
      ),
    );
  }




  editProfilePage()
  {

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
