import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/InfluencerHome/allCampaigns.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

class CampaignDetails extends StatefulWidget {
  final String id;

  final dynamic data;

  CampaignDetails({@required this.id, @required this.data});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CampaignDetails>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CampaignDetails> {
  Map<String, Object> tabsValue = new Map();
  List<Widget> tabList = [];
  List<Widget> tabView = [];

  TabController primaryTC;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    print(widget.data);

    tabsValue.putIfAbsent("Instagram", () => widget.data["isInstagram"]);
    tabsValue.putIfAbsent("Facebook", () => widget.data["isFacebook"]);
    tabsValue.putIfAbsent("Youtube", () => widget.data["isYoutube"]);

    if (widget.data["isInstagram"] == 1) {
      tabList.add(Tab(text: "Instagram"));
      tabView.add(Text('This is tab one'));
    }

    if (widget.data["isFacebook"] == 1) {
      tabList.add(Tab(text: "Facebook"));
      tabView.add(Text('This is tab one'));
    }

    if (widget.data["isYoutube"] == 1) {
      tabList.add(Tab(text: "Youtube"));
      tabView.add(Text('This is tab one'));
    }

    primaryTC = new TabController(length: tabList.length, vsync: this);
  }

  double width = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    //var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return   Scaffold(
      appBar: AppBar(
        leading: Functions.backButton(context),
          elevation: 1,
          title: Text(widget.data["campaign_name"]),
          backgroundColor: LocalColors.backgroundLight,
      ),
        
        backgroundColor: LocalColors.backgroundLight,


              body: DefaultTabController(
                  length: tabList.length,
                  child:  NestedScrollView(


                    headerSliverBuilder: (context,_){
                      return [


                        SliverList(
                          delegate: SliverChildListDelegate(
                            [Container(
                              height: 110,
                              width: width - 26,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: new BoxDecoration(
                                        image: widget.data["logo"] == ""
                                            ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                           Variables.ourImage,
                                          ),
                                        )
                                            : DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            widget.data["logo"],
                                          ),
                                        ),
                                        borderRadius: new BorderRadius.all(
                                            const Radius.circular(50.0)),
                                      ),
                                    ),
                                    top: 14  ,
                                    left: 16,
                                  ),



                                  Positioned(
                                    left: 120,
                                    top: 20,
                                    child: Text(widget.data["brand_name"] ,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Roboto", fontSize: 24, color: LocalColors.textColorDark ), ),

                                  ),
                                  Positioned(
                                    left: 120,
                                    top: 54,
                                    child: Container(
                                      child: Text(widget.data["description"]  + " d gd fg gf gd g  ds ds ds d fsg dg dg d gdg dg g d g d  skfms fs fs s fs f f",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontFamily: "Roboto", fontSize: 15, color: LocalColors.textColorLight ),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2
                                      ),
                                      width: width-120 - 14,
                                    )

                                  )
                                ],
                              )
                              ,
                            ),



Divider(),
                              Padding(
                                padding: EdgeInsets.only(left: 14,right: 14, top: 18, bottom: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("About Product", style: TextStyle(color: LocalColors.textColorDark, fontSize: 21, fontWeight: FontWeight.w500, fontFamily: "Roboto", letterSpacing: -0.5), ),

Container(height: 10,),
                                    Text(widget.data["product_name"]),

                                    Container(height: 12,),
                                    Text(widget.data["product_description"] , maxLines: 5, overflow: TextOverflow.visible,),

                                    Container(height: 14,),

                                    Container(height: 180,child: CachedNetworkImage(
                                      imageUrl: Variables.ourImage,
                                    ),),


                                    Container(height: 14,),

                                    Divider(),

                                    Container(height: 14,),

                                    Text("Do's", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16 ), maxLines: 8, overflow: TextOverflow.visible,),

                                    Container(height: 4,),

                                    Text(widget.data["dos"], ),

                                    Container(height: 14,),

                                    Text("Dont's", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16 ), maxLines: 8, overflow: TextOverflow.visible,),

                                    Container(height: 4,),

                                    Text(widget.data["donts"], ),

Divider()
                                  ],
                                ),
                              )


                            ]
                          ),
                        )
                      ];
                    },

                physics: const BouncingScrollPhysics(),
                    body: Column(
                      children: <Widget>[
                        Padding(
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: new BubbleTabIndicator(
                              indicatorHeight: 34.0,
                              indicatorColor: LocalColors.secondaryColor,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                            controller: primaryTC,
                            labelColor: Colors.white,
                            labelStyle:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            unselectedLabelColor: LocalColors.textColorLight,
                            tabs: tabList,
                          ),
                          padding: EdgeInsets.only(left: 13, right: 13),
                        ),

                        Expanded(
                          child: TabBarView(controller: primaryTC, children: tabView),
                        )
                      ],
                    ),


              )));

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
