import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

 import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/functions.dart';

import 'Keys.dart';


class PlacesSearch extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PlacesSearch> {

  TextEditingController _editingController = TextEditingController();

  String country = "";
  List<String> places = [];

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _editingController.text = country;
   }

  Future<String> getPlaces(String s) async {

    setState(() {
      isLoading = true;
    });
    try{
      var res = await http.get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=meerut&key="+Keys.mapKey+"&components=country:in");
      print(jsonDecode(res.body));

      places = ["sas","saaaaaaaaa"];
    }catch(e){
      debugPrint(e);
    }
    setState(() {
      isLoading = false;
    });
  }













  @override
  Widget build(BuildContext context) {
  return  Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: LocalColors.backgroundLight,
      title: Text("Select region"),
      leading: Functions.backButton(context)
    ),
    backgroundColor: LocalColors.backgroundLight,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        ListTile(
          title: TextFormField(

            controller: _editingController,
             decoration: InputDecoration(
              hintText: "Search..",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (s){
               if(s.length>2)
              getPlaces(s);

              else{
                setState(() {

                });
              }
            },

          ),
          trailing: _editingController.text.length!=0 ? IconButton(icon: Icon(Icons.clear,),onPressed: (){

            _editingController.text = "";
            setState(() {

            });
          },
          ): IconButton(icon: Icon(Icons.search,),onPressed: null,),
        ),
        Divider(thickness: 1.3,),
        ListTile(title: Text("Detect location"), trailing: Icon(Icons.gps_fixed, color: Colors.green,),),

      isLoading ? Padding(
        padding: EdgeInsets.only(left: 24,top: 20),
child: Container(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 1,),),
      ) : Expanded(
          child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (c, i){
            return(
              ListTile(title: Text(places[i],



              ),
                onTap: (){

                Navigator.pop(context,places[i]);
                },


              )
            );
          })
        )





      ],
    ),
  );
  }
}