import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final dynamic onTapWidget;
  final String image;
  final String title;
  final String subTitle;
  final dynamic titleColor;
  final dynamic widget;
  final dynamic fit;

  ExploreCard({this.onTapWidget,this.image,this.titleColor,this.title,this.subTitle,this.fit, this.widget});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>onTapWidget));
        },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'sf_pro_bold',
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),

                  SizedBox(width: 80,),
                  widget,


                ],
              ),
            ),
            decoration: BoxDecoration(
              color: white,
              boxShadow: [BoxShadow(color:Colors.black12,blurRadius: 10,offset: Offset(0.0,0.0),)],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit : fit,
                image: AssetImage(image),
              ),
            ),
          ),
        ),
    );
  }
}
