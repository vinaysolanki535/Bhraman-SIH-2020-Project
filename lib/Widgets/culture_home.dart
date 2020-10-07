
import 'package:bhrammanbeta/Screens/onTapCulture.dart';
import 'package:bhrammanbeta/data/data.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class Culture extends StatelessWidget {

  final List<Data> activities;
  Culture(this.activities);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index) {
          Data decoration = activities[index];
          return  GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> OnTapCulture(activities[index])
              ));
            },
            child: Card(
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),

                child: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height:270,
                        width: 180,
                        child:Stack(
                          children: [
                            Opacity(
                              opacity: 0.3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: black,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                height:270,
                                width: 180,
                              ),
                            ),

                            Container(
                              height: 270,
                              width: 180,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(decoration.imageUrl),
                                ),
                              ),
                            ),



                            Positioned(
                              left: 10.0,
                              bottom: 8.0,
                              right: 10.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        decoration.place,
                                        style: TextStyle(
                                            color: white,
                                            fontFamily: 'sf_pro_bold',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        decoration.city,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 16.0),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
          );
        },
      ),
    );
  }
}
