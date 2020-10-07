
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class TopOfHome extends StatelessWidget {

  final String topImageUrl,profileImageUrl,cityName;

  TopOfHome({this.topImageUrl,this.profileImageUrl,this.cityName});


  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height*0.30,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            //head image......

            Container(
              height: MediaQuery.of(context).size.height*0.30,
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(topImageUrl),
              ),
            ),


            Opacity(
              opacity: 0.1,
              child: Container(
                height: MediaQuery.of(context).size.height*0.30,
                width: MediaQuery.of(context).size.width,
                color: black,
              ),
            ),


            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(30),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Welcome to $cityName",
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: profileImageUrl == null ?  AssetImage('assets/icons/profile_avatar.png')
                           : NetworkImage(profileImageUrl),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
