import 'package:flutter/material.dart';
AppBar header(ctx, {bool isTitle=false,required String titleText,removeBackBotton=false}){
  return AppBar(
    automaticallyImplyLeading: removeBackBotton?false:true,
    title: Center(child: Text(

    titleText,
      style:const TextStyle(
          color:Colors.white,

      fontSize:  40,
        fontFamily: 'Signatra'
      ) ,)),
  );
}