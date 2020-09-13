import 'dart:convert';
import 'dart:ui';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:marketing/InfluencerHome/allCampaigns.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:we_slide/we_slide.dart';

class CampaignDetails2 extends StatefulWidget {
  final String id;

  final dynamic data;

  CampaignDetails2({@required this.id, @required this.data});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CampaignDetails2>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CampaignDetails2> {
  Map<String, Object> tabsValue = new Map();
  List<Widget> tabList = [];
  List<Widget> tabView = [];

  int sliderType = 0; //0 for instagram, 1 for facebook, 2 for youtube

  PanelController slideController = PanelController();
  TabController primaryTC;

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    print(widget.data);

    tabsValue.putIfAbsent("Instagram", () => widget.data["isInstagram"]);
    tabsValue.putIfAbsent("Facebook", () => widget.data["isFacebook"]);
    tabsValue.putIfAbsent("Youtube", () => widget.data["isYoutube"]);

    primaryTC = new TabController(length: tabList.length, vsync: this);
  }

  double width = 0;
  double height = 0;

  bool isSliderOpen = false;

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    tabList.clear();
    if (widget.data["isInstagram"] == 1) {
      tabList.add(Stack(
        children: <Widget>[
          Positioned(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(50.0)),
                    color: Colors.black12.withAlpha(6)),
              ),
              top: 0,
              left: 0),
          IconButton(
            icon: Icon(
              MaterialCommunityIcons.instagram,
              size: 26,
            ),
            color: Colors.pink,
            onPressed: () {
              sliderType = 0;
              slideController.open();
            },
          )
        ],
      ));
    }

    if (widget.data["isFacebook"] == 1) {
      tabList.add(IconButton(
        icon: Icon(MaterialCommunityIcons.facebook, size: 26),
        color: Colors.blueAccent,
        onPressed: () {
          sliderType = 1;
          slideController.open();
        },
      ));
    }

    if (widget.data["isYoutube"] == 1) {
      tabList.add(IconButton(
        icon: Icon(
          MaterialCommunityIcons.youtube,
          size: 26,
          color: Colors.red,
        ),
        onPressed: () {
          sliderType = 2;
          slideController.open();
        },
      ));
    }

    super.build(context);
  //  final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    //var tabBarHeight = primaryTabBar.preferredSize.height;
//    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        leading: Functions.backButton(context),
        elevation: 1,
        title: Text(widget.data["campaign_name"]),
        backgroundColor: LocalColors.backgroundLight,
      ),
      backgroundColor: LocalColors.backgroundLight,
      body: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: 0,
        parallaxEnabled: true,
        controller: slideController,
        parallaxOffset: 0.2,
        backdropEnabled: true,
        body: _body(width),
        panelBuilder: (sc) {
          if (sliderType == 0)
            return openInstagram(sc);
          else if (sliderType == 1)
            return openFacebook(sc);
          else
            return openYoutube(sc);
        },
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState(() {
          _fabHeight =
              pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        }),
      ),
    );
  }

  Widget openInstagram(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: <Widget>[
            ListView(
              controller: sc,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Instagram Requirements",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0,
                          color: Colors.pink),
                    ),
                  ],
                ),
                Divider(
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(
                  height: 36.0,
                ),
                widget.data['insta_tags'].trim() != ""
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Tags to be used",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['insta_tags'],
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.black87.withAlpha(180)),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data['insta_hash_tags'].trim() == ""
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Hashtags to be used",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['insta_hash_tags'],
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                widget.data["insta_min_followers"] != 0
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Minimum followers",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['insta_min_followers'].toString(),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data["insta_something_else"] != null
                    ? widget.data["insta_something_else"].trim() != ""
                        ? widget.data["insta_something_else"].toLowerCase() !=
                                    "no" &&
                                widget.data["insta_something_else"]
                                        .toLowerCase() !=
                                    "null"
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.data['insta_something_else'],
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                        : Container()
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Image to be posted",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(
                            height: 12.0,
                          ),
                          SizedBox(
                            height: 200,
                            width: 170,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                                    ),
                                    fit: BoxFit.fill),
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(10.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  child: Text("Reference Image",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  padding: EdgeInsets.only(left: 24),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 24,
                    ),
                    SizedBox(
                      height: 200,
                      width: 170,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                              ),
                              fit: BoxFit.fill),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 160.0,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: Padding(
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 55,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Place a bid",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: LocalColors.secondaryColor,
                    onPressed: () {
                      linkIgFromAllCamp();
                    },
                  ),
                ),
                padding: EdgeInsets.only(left: 24, right: 24),
              ),
            )
          ],
        ));
  }

  Widget openFacebook(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: <Widget>[
            ListView(
              controller: sc,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Facebook Requirements",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
                Divider(
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(
                  height: 36.0,
                ),
                widget.data['fb_tags'].trim() != ""
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Tags to be used",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['fb_tags'],
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.black87.withAlpha(180)),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data['fb_hash_tags'].trim() != ""
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Hashtags to be used",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['fb_hash_tags'],
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data["fb_min_likes"] != 0
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Minimum likes",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['fb_min_likes'].toString(),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data["fb_something_else"] != null
                    ? widget.data["fb_something_else"].trim() != ""
                        ? widget.data["insta_something_else"].toLowerCase() !=
                                    "no" &&
                                widget.data["fb_something_else"]
                                        .toLowerCase() !=
                                    "null"
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.data['fb_something_else'],
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                        : Container()
                    : Container(),
                widget.data["fb_your_post"].trim() == ""
                    ? Container()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Reference Image",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                SizedBox(
                                  height: 12.0,
                                ),
                                SizedBox(
                                  height: 200,
                                  width: 170,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                                          ),
                                          fit: BoxFit.fill),
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 24.0,
                ),
                widget.data["fb_reference"].trim() == ""
                    ? Container()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Reference Image",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                SizedBox(
                                  height: 12.0,
                                ),
                                SizedBox(
                                  height: 200,
                                  width: 170,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                                          ),
                                          fit: BoxFit.fill),
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 160.0,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: Padding(
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 55,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Place a bid",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: LocalColors.secondaryColor,
                    onPressed: () {
                      linkFbFromAllCamp();
                    },
                  ),
                ),
                padding: EdgeInsets.only(left: 24, right: 24),
              ),
            )
          ],
        ));
  }

  Widget openYoutube(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: <Widget>[
            ListView(
              controller: sc,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Youtube Requirements",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0,
                          color: Colors.red),
                    ),
                  ],
                ),
                Divider(
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(
                  height: 36.0,
                ),
                widget.data['yt_hash_tags'].trim() == ""
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Hashtags to be used",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['yt_hash_tags'],
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                widget.data["yt_min_subs"] != 0
                    ? Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Minimum Subscribers",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.data['yt_min_subs'].toString(),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.data["yt_something_else"] != null
                    ? widget.data["yt_something_else"].trim() != ""
                        ? widget.data["yt_something_else"].toLowerCase() !=
                                    "no" &&
                                widget.data["yt_something_else"]
                                        .toLowerCase() !=
                                    "null"
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.data['yt_something_else'],
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                        : Container()
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Youtube Reference",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(widget.data["yt_reference"])
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 160.0,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: Padding(
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 55,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Place a bid",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: LocalColors.secondaryColor,
                    onPressed: () {
                      linkYtFromAllCamp();
                    },
                  ),
                ),
                padding: EdgeInsets.only(left: 24, right: 24),
              ),
            )
          ],
        ));
  }

  Widget _body(width) {
    return Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
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
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(50.0)),
                      ),
                    ),
                    top: 14,
                    left: 16,
                  ),
                  Positioned(
                    left: 120,
                    top: 20,
                    child: Text(
                      widget.data["brand_name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Roboto",
                          fontSize: 24,
                          color: LocalColors.textColorDark),
                    ),
                  ),
                  Positioned(
                      left: 120,
                      top: 53,
                      child: Container(
                        child: Text(widget.data["description"],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                color: LocalColors.textColorLight),
                            overflow: TextOverflow.clip,
                            maxLines: 3),
                        width: width - 120 - 14,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "About Product",
                    style: TextStyle(
                        color: LocalColors.textColorDark,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        letterSpacing: -0.5),
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(widget.data["product_name"]),
                  Container(
                    height: 12,
                  ),
                  Text(
                    widget.data["product_description"],
                    maxLines: 5,
                    overflow: TextOverflow.visible,
                  ),
                  Container(
                    height: 14,
                  ),
                  Container(
                    height: 180,
                    child: CachedNetworkImage(
                      imageUrl: Variables.ourImage,
                    ),
                  ),
                  Container(
                    height: 14,
                  ),
                  Divider(),
                  Container(
                    height: 14,
                  ),
                  Text(
                    "Do's",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    maxLines: 8,
                    overflow: TextOverflow.visible,
                  ),
                  Container(
                    height: 4,
                  ),
                  Text(
                    widget.data["dos"],
                  ),
                  Container(
                    height: 14,
                  ),
                  Text(
                    "Dont's",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    maxLines: 8,
                    overflow: TextOverflow.visible,
                  ),
                  Container(
                    height: 4,
                  ),
                  Text(
                    widget.data["donts"],
                  ),
                  Divider()
                ],
              ),
            )
          ],
        ),
        Positioned(
          bottom: 120,
          child: Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Container(
              width: width - 36,
              height: 70,
              child: Center(
                child: Container(
                  width: width - 40,
                  child: Wrap(
                      alignment: WrapAlignment.spaceEvenly, children: tabList),
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                ],
                color: Colors.white,
                borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
              ),
            ),
          ),
        ),
        /*  Positioned(
                  top: 0,
                  child: ClipRRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).padding.top,
                            color: Colors.transparent,
                          )
                      )
                  )
              ),*/
      ],
    );
  }

  Future<void> linkFbFromAllCamp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account not verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Go to profile section and verify social media handles'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> linkIgFromAllCamp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account not verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Go to profile section and verify social media handles'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> linkYtFromAllCamp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account not verified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Go to profile section and verify social media handles'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
