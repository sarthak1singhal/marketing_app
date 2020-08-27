import 'dart:async';
import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extend;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'allCampaigns.dart';

class Home extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home>    with SingleTickerProviderStateMixin,    AutomaticKeepAliveClientMixin<Home> {



  TabController primaryTC;

  @override
  void initState() {
    primaryTC = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
//var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return Scaffold(

      backgroundColor: LocalColors.backgroundLight,
        body: DefaultTabController(
          length: 2,
          child: extend.NestedScrollView(
              headerSliverBuilder: (c, f) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: LocalColors.backgroundLight,
                    pinned: false,
                    snap: false,
                    floating: false,
                    expandedHeight: 83,
                     flexibleSpace:  FlexibleSpaceBar(

                      titlePadding: EdgeInsets.only(left: 26, bottom: 20),
                      title: Text('Hey, ${Variables.firstName}',
                        style: TextStyle(fontWeight: FontWeight.w700, wordSpacing: 1.5, fontFamily: "Roboto", color: LocalColors.textColorDark ), ),
                    ),
                  ),

                ];

              },
              pinnedHeaderSliverHeightBuilder: () {
                return statusBarHeight+5;
              },
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
                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      unselectedLabelColor: LocalColors.textColorLight,
                      tabs: [
                        Tab(text: "For Me"),
                        Tab(text: "All Campaigns"),

                      ],
                    ),
                      padding: EdgeInsets.only(left: 13,right: 13),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: primaryTC,
                      children: <Widget>[
                        Text('This is tab one'),
                        AllCampaigns(),

                      ],
                    ),
                  )
                ],
              )

          ),
        )
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



}
























