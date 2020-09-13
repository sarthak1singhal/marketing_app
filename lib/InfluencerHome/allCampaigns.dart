import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:marketing/Influencer/CampaignDetails.dart';
import 'package:marketing/Influencer/CampaignDetails2.dart';
import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllCampaigns extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AllCampaigns>
    with AutomaticKeepAliveClientMixin<AllCampaigns> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController controller = ScrollController();

  bool isMore = true;
  bool moreLoad = false;

  @override
  void initState() {
    super.initState();
    loadData();
    controller.addListener(() async {
      double max = controller.position.maxScrollExtent;
      double current = controller.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (isMore) {
        if (max - current <= delta) {
          getMore();
        }
      }
    });
  }

  void getMore() async {
    if (!isMore) {
      return;
    }
    if (!moreLoad) {
      moreLoad = true;
      setState(() {});

      var res = await Functions.postReq(
          Variables.AllCampaigns, jsonEncode({"page": pageNo.toString()}), context);

      var s = jsonDecode(res.body);
      if (!s["isError"]) {
        dynamic l = s["data"];
        list = list + l;
        pageNo++;
        if (l.length < 10) {
          isMore = false;
        }
      }

      setState(() {});
      moreLoad = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = true;
  int pageNo = 0;

  dynamic list = [];

  loadData() async {
    if (list.length == 0) {
      var res = await Functions.postReq(
          Variables.AllCampaigns, jsonEncode({"page": pageNo.toString()}), context);

      var s = jsonDecode(res.body);

      if (!s["isError"]) {
        list = s["data"];

        pageNo++;
        if (list.length < 10) {
          isMore = false;
        }
      }

      //print(list);


      setState(() {
        isLoading = false;
      });
    }
  }

  double width = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        isLoading
            ? Functions.showLoader()
            : ListView.builder(
                controller: controller,
                itemCount: list.length,
                itemBuilder: (c, i) {
                  return Container(
                      //constraints: BoxConstraints(minHeight: 110, maxHeight: 150),
                      height: 160,
                       child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 20,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: 140,
                                        maxHeight: 140,
                                        maxWidth: width - 30,
                                        minWidth: width - 30),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        shadowColor: Colors.black54,
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 70,
                                              right: 8,
                                              top: 13,
                                              bottom: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                list[i]["brand_name"],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Container(
                                                height: 6,
                                              ),
                                              Text(
                                                list[i]["campaign_name"],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Container(
                                                height: 11,
                                              ),
                                              Text(
                                                  list[i]
                                                      ["product_description"],
                                                  style: TextStyle(
                                                      color: LocalColors
                                                          .textColorLight),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                Positioned(
                                    left: 7,
                                    top: 12,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      shadowColor: Colors.black54,
                                      elevation: 1,
                                      child:list[i]["logo"]==""?

                                      Container(
                                        child:  Icon(
                                          Icons.person,
                                          color: Colors.white60,
                                          size: 35,
                                        ),
                                        width: 67,
                                        height: 67,
                                        //  color: Colors.grey,
                                        decoration: new BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: new BorderRadius.all(
                                              const Radius.circular(10.0)),
                                        ),
                                      )

                                          :Container(
                                        width: 67,
                                        height: 67,
                                        //  color: Colors.grey,
                                        decoration: new BoxDecoration(
                                           image: DecorationImage(
                                             image: CachedNetworkImageProvider("http://via.placeholder.com/350x350",
                                             ),
                                           ),
                                           borderRadius: new BorderRadius.all(
                                              const Radius.circular(10.0)),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  right: 29,
                                  bottom: 32,
                                  child: Container(
                                    height: 30,
                                    width: 84,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 5,
                                      children: <Widget>[
                                        list[i]["isFacebook"] == 1
                                            ? Icon(
                                                MaterialCommunityIcons.facebook,
                                                size: 19,
                                                color: Colors.blue,
                                              )
                                            : Icon(
                                                MaterialCommunityIcons.facebook,
                                                size: 19,
                                                color: Colors.white,
                                              ),
                                        list[i]["isInstagram"] == 1
                                            ? Icon(
                                                MaterialCommunityIcons
                                                    .instagram,
                                                size: 20,
                                                color: Colors.pink,
                                              )
                                            : Icon(
                                                MaterialCommunityIcons.facebook,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                        list[i]["isYoutube"] == 1
                                            ? Icon(
                                                MaterialCommunityIcons.youtube,
                                                size: 21,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                MaterialCommunityIcons.facebook,
                                                size: 21,
                                                color: Colors.white,
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CampaignDetails2(id: list[i]["id"],data: list[i])),
                              );

                            },
                          ),

                          //type==0 || isSearching ? searchable[i].uploaderName == uid ? getPopup(i,2) : Container():list[i].uploaderName == uid ? getPopup(i,1) : Container()
                        ],
                      ));
                })
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



