import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class HorizontalCard extends StatelessWidget {

  final dynamic thumbnailUrl,placeName,userName,onTapWidget,height,width;
  HorizontalCard({this.thumbnailUrl,this.placeName,this.userName,this.onTapWidget,this.height,this.width});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
      child: Container(
        height: height,
        width:  width,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.black12],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    placeName,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'sf_pro_bold',
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2, vertical: 10),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      color: lightGrey,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star,
                          color: Colors.orange, size: 15.0),
                      Icon(Icons.star,
                          color: Colors.orange, size: 15.0),
                      Icon(Icons.star,
                          color: Colors.orange, size: 15.0),
                      Icon(Icons.star,
                          color: Colors.orange, size: 15.0),
                      Icon(Icons.star,
                          color: Colors.orange, size: 15.0),
                      Text('('+'4.5'+')Rating',style: TextStyle(
                          color: lightGrey,
                          fontSize: 14,
                          fontFamily: 'sf_pro_regular'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image:NetworkImage(thumbnailUrl),
          ),
        ),
      ),
    );
  }
}
