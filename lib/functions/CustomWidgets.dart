import 'package:flutter/material.dart';

import 'LocalColors.dart';


class CustomWidgets{



  static loadingFlatButton (bool isLoading, Function onPressed)
  {
    return   FlatButton(
        child: isLoading ? Container(height: 16,width: 16,child: CircularProgressIndicator(strokeWidth: 1.5,),):Text("SAVE"),
  disabledColor: LocalColors.backgroundLight,

  onPressed: isLoading ? null :
      onPressed
    );
  }

}