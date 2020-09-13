import 'dart:convert';
 import 'dart:io';
import 'dart:typed_data';

 import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marketing/functions/CustomWidgets.dart';
import 'package:marketing/functions/Keys.dart';
 import 'package:marketing/functions/LocalColors.dart';
import 'package:marketing/functions/PlacesSearch.dart';
import 'package:marketing/functions/functions.dart';
import 'package:marketing/functions/variables.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {

  var data;

  EditProfile(this.data);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String f_name = "";
  String l_name = "";

  List<String> content_category = [];
   final format = DateFormat("dd/MM/yyy");

  String gender = "";

  DateTime birthDate ;

  String city = "";
  String country = "";
  String about = "";



  List<dynamic> content_languages = [];


  @override
  void initState() {
    super.initState();


    print(widget.data);
    f_name  = Functions.isNullEmptyOrFalse(widget.data["user"]["f_name"]) ? "" : widget.data["user"]["f_name"];
    l_name  = Functions.isNullEmptyOrFalse(widget.data["user"]["l_name"]) ? "" : widget.data["user"]["l_name"];
    if(!Functions.isNullEmptyOrFalse(widget.data["about"]["content_category"]))
      {
        content_category.add(widget.data["about"]["content_category"]);

       }
    if(!Functions.isNullEmptyOrFalse(widget.data["about"]["content_category2"])){

      content_category.add(widget.data["about"]["content_category2"]);
    }
    if(!Functions.isNullEmptyOrFalse(widget.data["about"]["birth_date"])){
      var d = widget.data["about"]["birth_date"].split("-");
      if(d.length ==3)
      birthDate = DateTime.utc(int.parse(d[0]),int.parse(d[1]),int.parse(d[2].substring(0,2)));
    }

    if(!Functions.isNullEmptyOrFalse(widget.data["about"]["gender"])){
        gender = widget.data["about"]["gender"];
    }else{
      gender = "No";
    }

    if(!Functions.isNullEmptyOrFalse(widget.data["user"]["about_me"])){
      about = widget.data["user"]["about_me"];
    }

    if(!Functions.isNullEmptyOrFalse(widget.data["countries"]) ){
      country = widget.data["countries"];
      if(country == "") country = "India";
    }else{
      if(country == "") country = "India";
    }


    if(widget.data["languages"].length != 0){
      content_languages = widget.data["languages"];
      if(content_languages.length == 0)
        {
          content_languages.add("English");
        }



    }else{
        content_languages.add("English");
    }




      if(!Variables.genders.contains(gender.substring(0,1).toUpperCase() + gender.substring(1,gender.length)))
    {
      
      gender  = "1";
    }
  }

  String type = "influencer";


  bool isLoading = false;



  save() async{

    if(content_category.length==0 || content_category.length>2){ Functions.showSnackBar(_scaffoldKey, "You can select atmost 2 content categories"); return;}


    if(gender =="1") {Functions.showSnackBar(_scaffoldKey, "Select a gender"); return;}


    if(Functions.isNullEmptyOrFalse(birthDate)) {
      Functions.showSnackBar(_scaffoldKey, "Select your birth date"); return;
    }

    if(Functions.isNullEmptyOrFalse(country)) {
      Functions.showSnackBar(_scaffoldKey, "Select a country"); return;
    }

    if(_formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });



     String month =  birthDate.month.toString().length ==1 ? "0" + birthDate.month.toString():birthDate.month.toString();
     String date =  birthDate.day.toString().length ==1 ? "0" + birthDate.day.toString():birthDate.day.toString();

      try{
        print(content_category);
        var res = await  Functions.postReq("edit-profile", jsonEncode({
          "f_name" : f_name,
          "l_name" : l_name,
          "category" : content_category[0],
          "category1" : content_category.length == 0 ? "":content_category[1],
          "gender": gender == "1"?"":gender,
          "birth_date": birthDate.year.toString() +"-"+ month+ "-"+ date,
          "country" : country.split(",").length == 2? country.split(",")[1] : country,
          "region" : country.split(",").length ==2 ? country: "",
          "languages" : content_languages,
          "about_me" : about.trim()

        }), context);



        var s = jsonDecode(res.body);
        print(s);


        if(s["isError"])
        {
          if(s["message"]!=null){
            Functions.showSnackBar(_scaffoldKey, s["message"]);

          }
        }else{

          widget.data["countries"] = country;
          widget.data["languages"] = content_languages;
          Navigator.pop(context);
        }
        setState(() {
          isLoading = false;
        });

      }
      catch(e){

        setState(() {
          isLoading = false;
        });

        print(e);
        Functions.showSnackBar(_scaffoldKey, "There was some error");

      }

     }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.backgroundLight,
      appBar: AppBar(

        backgroundColor: LocalColors.backgroundLight,
        elevation: 1,
        leading: Functions.backButton(context),
        title: Text("Edit"),

        actions: <Widget>[
          CustomWidgets.loadingFlatButton(isLoading, (){save();})
       /*   FlatButton(
            child: isLoading ? Container(height: 16,width: 16,child: CircularProgressIndicator(strokeWidth: 1.5,),):Text("SAVE"),
disabledColor: LocalColors.backgroundLight,

            onPressed: isLoading ? null : (){

              save();

            },
          )*/
        ],
      ),
      key: _scaffoldKey,

      body:GestureDetector(
        child:  ListView(

          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(height: 30,),
            getProfileImage(MediaQuery.of(context).size.width),

            Padding(padding: EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 40),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                       TextFormField(

                         initialValue: f_name,
                         decoration: InputDecoration(
                           labelText: "First Name",
                           labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                         ),
                        onChanged: (s){
                          f_name = s;
                        },
                        validator: (s){
                          if(s.isEmpty){
                            return "Enter a valid name";
                          }
                          if(s.length<3)
                            return "Enter a valid name";
                          if(s.trim().contains(" ")){
                            return "Enter only first name";
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,

                      ),

                      Container(height: 24,),

                      TextFormField(
                        initialValue: l_name,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          l_name = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isEmpty){
                            return "Enter a valid last name";
                          }
                          if(s.length<3)
                            return "Enter a valid last name";
                          if(s.trim().contains(" ")){
                            return "Enter only last name";
                          }
                          return null;
                        },

                      ),


                      Container(height: 24,),

                      TextFormField(
                        maxLines: 5,
                        minLines: 2,
                        initialValue: about,
                        decoration: InputDecoration(
                          labelText: "About Me",
                          labelStyle: TextStyle(color: Colors.black54, fontFamily: Variables.fontName),

                        ),
                        onChanged: (s){
                          about = s;
                        },
                        textCapitalization: TextCapitalization.words,

                        validator: (s){

                          if(s.isNotEmpty) {
                            if (s.length > 300)
                              return "Limited to 300 characters";

                          }
                          return null;
                        },

                      ),


                      Container(height: 30,),

                      contentCategoriesWidget(context),


                      Container(height: 30,),
                      Text("Gender", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                      Container(height: 12,),


                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton<String>(
                          value: Functions.isNullEmptyOrFalse(gender) ? "1" : gender,
                          icon: null,
                          elevation: 16,
                          style: TextStyle(color: Colors.black87),
                          underline: Container(
                            height: 1,
                            color: Colors.black38,
                          ),
                          onChanged: (String newValue) {
                            FocusScope.of(context).requestFocus(new FocusNode());

                            setState(() {
                              gender = newValue;
                            });
                            },
                          items:Variables.genders
                              .map<DropdownMenuItem<String>>((String value) {
                                print(value);
                                if(value == "1")
                                  {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text("Not Set", style: TextStyle(color: Colors.black38),),
                                    );
                                  }
                            return DropdownMenuItem<String>(
                              value: value.toLowerCase(),
                              child: Text(value),
                            );
                          }).toList(),
                        )
                        ,
                      ),



                      Container(height: 30,),
                      Text("Birth Date", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),

                      DateTimeField(

                        initialValue: birthDate == null ? null : birthDate,
                        //   controller: TextEditingController()..text = birtnDate.toUtc().toString(),
                        onChanged: (v) {
                          birthDate = v;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: 11, top: 11),
                          //  border: InputBorder.none,

                            focusedBorder: InputBorder.none,
                           ),
                        format: format,
                        readOnly: true,
                        enableInteractiveSelection: true,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1970,1,1),
                              initialDate: DateTime.now().subtract(Duration(days: 6620)),
                              lastDate: DateTime(4000,1,1));
                        },

                      ),


                      Container(height: 34,),




                      GestureDetector(
                       onTap: (){
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => PlacesSearch()),
                         );
                       },
                       child:Column(
                         crossAxisAlignment: CrossAxisAlignment.start,

                         children: <Widget>[
                           Text("Place", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),

                           Container(height: 14,),

                           Container(width: MediaQuery.of(context).size.width,
                           height: 30,
                             child: Text(country),
                             decoration: BoxDecoration(

                               border:Border(
                                 bottom: BorderSide(

                                     color: Colors.black38,
                                     width: 1.0
                                 ),
                               ),
                             ),
                           ),

                           Container(height: 36,),



                         ],
                       )
                     ),


                      contentLanguagesWidget(context),


                      Container(height: 40,),

                      Text("Note: The above information helps us to show you relevant campaigns")



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





  Widget contentLanguagesWidget(context){
    return GestureDetector(
      onTap: (){
        _showMultiSelectLanguages(context);
        FocusScope.of(context).requestFocus(new FocusNode());

      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Languages that you post content in", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),


          ConstrainedBox
            (
              constraints: BoxConstraints(
                  minHeight: 50
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border:  Border(
                      bottom: BorderSide(

                          color: Colors.black38,
                          width: 1.0
                      ),
                    ),

                  ),
                  child: Padding(
                    child: MultiSelectChipDisplay(
                      chipColor: Colors.blue,
                      opacity: 0.9,
                      textStyle: TextStyle(color: Colors.white),
                      items: content_languages.map((e) => MultiSelectItem(e, e)).toList(),
                      onTap: (value) {
                        setState(() {
                          content_languages.remove(value);
                        });
                      },
                    ),
                    padding: EdgeInsets.all(10),
                  )



              )

          ),
        ],
      ),
    )
    ;
  }

  void _showMultiSelectLanguages(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {

        return  MultiSelectBottomSheet(
          titleText: "If you put regional content, select your language",

          chipColor: Colors.blue,
          selectedColor: Color.fromRGBO(33, 150, 240, 0.3),



          itemsTextStyle: TextStyle(
              color: Colors.white
          ),

          searchable: true,




          initialChildSize: 0.45,


          confirmText: Text("OK", style: TextStyle(color: Colors.black87),),
          cancelText: Text("Cancel", style: TextStyle(color: Colors.black87),),
          listType: MultiSelectListType.CHIP,

          items: Variables.languages.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: content_languages,
          onConfirm: (values) {

            content_languages = values;
            setState(() {

            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }
































  Widget contentCategoriesWidget(context){
    return GestureDetector(
      onTap: (){
        _showMultiSelect(context);
        FocusScope.of(context).requestFocus(new FocusNode());

      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Content Categories", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),


          ConstrainedBox
            (
              constraints: BoxConstraints(
                  minHeight: 50
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border:  Border(
                      bottom: BorderSide(

                          color: Colors.black38,
                          width: 1.0
                      ),
                    ),

                  ),
                  child: Padding(
                    child: MultiSelectChipDisplay(
                      chipColor: Colors.blue,
                      opacity: 0.9,
                      textStyle: TextStyle(color: Colors.white),
                      items: content_category.map((e) => MultiSelectItem(e, e)).toList(),
                      onTap: (value) {
                        setState(() {
                          content_category.remove(value);
                        });
                      },
                    ),
                    padding: EdgeInsets.all(10),
                  )



              )

          ),
        ],
      ),
    )
;
  }

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {

        return  MultiSelectBottomSheet(
          titleText: "Select upto 2 content categories",

          chipColor: Colors.blue,
          selectedColor: Color.fromRGBO(33, 150, 240, 0.3),



          itemsTextStyle: TextStyle(
  color: Colors.white
),

          searchable: true,




          initialChildSize: 0.45,


          confirmText: Text("OK", style: TextStyle(color: Colors.black87),),
          cancelText: Text("Cancel", style: TextStyle(color: Colors.black87),),
          listType: MultiSelectListType.CHIP,

          items: Variables.contentCategories.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: content_category,
          onConfirm: (values) {

            content_category = values;
            setState(() {

            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }




  Widget getProfileImage(width){
    return Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: width / 2 - 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: Functions.isNullEmptyOrFalse(Variables.profile_image)?  new BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: new BorderRadius.all(
                    const Radius.circular(80.0)),
              ) : BoxDecoration(
                borderRadius: new BorderRadius.all(
                    const Radius.circular(80.0)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      Variables.profile_image
                  )
                )
              ),
            ),
          ),
          Positioned(
            top: 116.7,
            left: width / 2 + 20.7,
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 23,
            ),
          )
        ,Positioned(
            top: 116,
            left: width / 2 + 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 23,
            ),
          )
               , Positioned(
            top: 114.5,
            left: width / 2 + 19.5,
            child: IconButton(
                iconSize: 20,
                color: LocalColors.secondaryColor,
                icon: Icon(Icons.edit),
                onPressed: () {
                  getImage();
                  //   _profileImage = b1.getFile();
                  // int h  = 0;
                }),
          )

        ],
      ),
    );
  }



 /* Widget getProfileImage(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(

              child: Functions.isNullEmptyOrFalse(Variables.profile_image)? Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(80))
                ),
              ):Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          Variables.profile_image
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(80))
                ),
              ),
            ),

            Positioned(
              bottom:0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
              ),
            ),
            Positioned(
              bottom: -7,
              right: -9,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){

                },
              ),
            )
          ],
        )

      ],
    );
  }
*/








  Future getImage() async {
    File compressedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,

        imageQuality: 90,
        maxHeight: 1280,
        maxWidth: 1280);


    File croppedFile = await ImageCropper.cropImage(
        compressQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
        sourcePath: compressedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.white,

            hideBottomControls: true,
            toolbarWidgetColor: Colors.black87,
            activeControlsWidgetColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(

          minimumAspectRatio: 1.0,
        ));
    Uint8List u;
    if (croppedFile != null) u = croppedFile.readAsBytesSync();

    setState(() {
      if (croppedFile != null) {

submitForm(Variables.baseUrl + Variables.uploadProfileImg, croppedFile, compressedImage.path.split('/').last);



      }
    });
  }

  submitForm(String link, File _image, name) async {

    Dio dio = new Dio();

    isLoading = true;
    setState(() {

    });
      FormData formdata = new  FormData.fromMap({"file":  base64Encode(_image.readAsBytesSync()), "name" :name  });
    //formdata.files.add(MapEntry("file",new MultipartFile.fromBytes(bytes)));

     dio.post(link, data: formdata, options: Options(
        method: 'POST',
        responseType: ResponseType.json,
      headers: {
        "token": Variables.token
      },

    ))
        .then((response) {

          print(response.data.toString());
          if(!response.data["isError"])
            {
              if(response.data["data"]!=null)
                Variables.profile_image = response.data["data"];

            }
          setState(() {
            isLoading = false;
          });

     }
     )
        .catchError((error) {
          setState(() {

            isLoading = false;
          });
     });


/*
    final response = await http.post(
      link,
      headers: {
        "token": Variables.token
      },
      body: {

        'file': _image != null ?
            base64Encode(_image.readAsBytesSync()) : '',
        'name' : "biyyu"

      },
    );

    final responseJson = json.decode(response.body);
    print(responseJson);
*/


  }



}
