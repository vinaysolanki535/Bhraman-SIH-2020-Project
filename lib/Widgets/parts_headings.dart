import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class PartsHeading extends StatelessWidget {

  final String headText;
  PartsHeading({this.headText});
  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            headText,
            style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'sf_pro_bold',
                color: black),
          ),
          GestureDetector(
            onTap: (){
              print(headText);
            },
            child: Text(
              'View all',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'sf_pro_regular',
                  color: grey),
            ),
          ),
        ],
      ),
    );
  }
}
