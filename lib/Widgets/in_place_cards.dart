import 'dart:ui';

import 'package:flutter/material.dart';

class InPlaceCard extends StatelessWidget {



  final String imageUrl,name;
  final Widget onTapWidget;
  InPlaceCard({this.imageUrl,this.name,this.onTapWidget});


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
           builder: (context) => onTapWidget,
        ));
      },
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),

          ),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 0.0, sigmaY: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0)),
                    ),
                  ),
                  height: 200,

                ),
                Center(
                  child: Text(name, style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      shadows: [BoxShadow(blurRadius: 10,color: Colors.black54,offset: Offset(0.0,0.0))],
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
