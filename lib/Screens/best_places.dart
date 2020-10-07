import 'package:bhrammanbeta/Screens/on_tap_places.dart';
import 'package:bhrammanbeta/data/best_places.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

class BestPlaces extends StatefulWidget {
  final String city;
  BestPlaces({this.city});

  @override
  _BestPlacesState createState() => _BestPlacesState();
}

class _BestPlacesState extends State<BestPlaces> {



  DatabaseService  _databaseService =  DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlacesData();
  }


  List<BestPlacesData> placesData = new List();

  getPlacesData() async {
    await _databaseService.getBestPlacesDataFireStore(city: widget.city).then((value) {

      setState(() {
        placesData =  value;
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
            children : [
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Row(
                            children: <Widget>[
                              Text(
                                'Places of ${widget.city}',
                                style: TextStyle(
                                    fontFamily: 'sf_pro_bold',
                                    color: white,
                                    shadows: [BoxShadow(color: black,blurRadius: 5,offset: Offset(0.0, 0.0))],
                                    fontSize: 35),
                              ),
                              SizedBox(width: 5,),
                              Icon(
                                Icons.location_on,
                                color: white,
                                size: 25,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    height: 250,
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.only(
                          bottomRight: const Radius.circular(25.0),
                          bottomLeft: const Radius.circular(25.0)),

                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/best_place.jpg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //one
                  //---------------------------------------------------
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(placesData.length, (index)  {
                        return  Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
                          child: GestureDetector(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => OnTapPlaces(placesData: placesData[index],)
                              ));
                            },
                            child: Container(
                              height: 200,
                              width:  MediaQuery.of(context).size.width,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      height: 80,
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
                                          placesData[index].place,
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
                                                color: Colors.yellow, size: 15.0),
                                            Icon(Icons.star,
                                                color: Colors.yellow, size: 15.0),
                                            Icon(Icons.star,
                                                color: Colors.yellow, size: 15.0),
                                            Icon(Icons.star,
                                                color: Colors.yellow, size: 15.0),
                                            Icon(Icons.star,
                                                color: Colors.white, size: 15.0),
                                            Text('('+'4.5'+')Rating',style: TextStyle(color: lightGrey,fontSize: 14,fontFamily: 'sf_pro_regular'),),
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
                                  image:NetworkImage(placesData[index].images[0]),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  ),
                ],
              ),

              //app bar//
              Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),

            ]
        ),
      ),
    );;
  }
}

