
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';



class Reviews extends StatelessWidget {

  final String profileImage,review,time,userName,date;
  final double rating;
  Reviews({this.profileImage,this.review,this.time,this.userName,this.date,this.rating});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: profileImage == null ? AssetImage(
                  'assets/images/manone.png'
              ) : NetworkImage(
                profileImage
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(userName,
                      style: TextStyle(
                          color: black,
                          fontSize: 18,
                          fontFamily: "sf_pro_bold"
                      ),
                    )
                ),

                SizedBox(height: 5,),


                Container(
                    width: MediaQuery.of(context).size.width*0.70,
                    child: Text(
                      review,
                      style: TextStyle(
                        fontFamily: "sf_pro_regular",
                      ),
                    )
                ),

                SizedBox(height: 10,),

                Container(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(time + " " + date,
                    style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  ),

                ),

                SmoothStarRating(

                  isReadOnly: true,
                  rating: rating,
                  starCount: 5,
                  color: Colors.orange,
                  size: 20,
                ),


              ],






            ),

          ),





        ],
      ),
    );
  }
}
