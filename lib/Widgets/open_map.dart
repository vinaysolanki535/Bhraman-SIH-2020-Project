import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';


class OpenMap extends StatelessWidget {
  final dynamic latitude;
  final dynamic longitude;
  final dynamic name;
  OpenMap({this.latitude, this.longitude,this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Container(

                padding: EdgeInsets.only(left: 15,right: 15),
                child: Text(
                  "Navigate",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'sf_pro_bold'
                  ),
                )
            ),

            GestureDetector(
              onTap: () async{
                await MapsLauncher.launchCoordinates(double.parse(latitude), double.parse(longitude));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  image: AssetImage(
                    'assets/images/maps.jpg'
                  ),
                ),
              ),
            ),


            Container(
              height: 0.5,
              color: Colors.grey,
            ),

            GestureDetector(
              onTap: ()async {await MapsLauncher.launchCoordinates(double.parse(latitude), double.parse(longitude));},
              child: Container(
                padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                child : Row(
                  children: [
                    Text(name,style: TextStyle(fontSize: 18,fontFamily: 'sf_pro_semi_bold'),),
                    SizedBox(width: 10,),
                    Icon(Icons.edit_location,color: Colors.lightBlue,),
                  ],
                )
              ),
            ),


            Container(
              height: 0.5,
              color: grey,
            )




          ],
        ),
    );
  }
}
