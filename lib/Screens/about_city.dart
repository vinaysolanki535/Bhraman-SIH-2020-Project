import 'package:bhrammanbeta/Widgets/open_map.dart';
import 'package:bhrammanbeta/data/about_city_data.dart';
import 'package:bhrammanbeta/data/review_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AboutCity extends StatefulWidget {
  final String city;
  final AboutCityData cityData;

  AboutCity({this.city,this.cityData});


  @override
  _AboutCityState createState() => _AboutCityState();
}

class _AboutCityState extends State<AboutCity> {


  FlutterTts  textToSpeech = FlutterTts();

  bool clickedOverView = false;
  bool clickedAbout = false;
  bool clickedHistory = false;



  DatabaseService databaseService =  DatabaseService();



  @override
  void initState() {
    // TODO: implement initState

    super.initState();


  }

  String languageChoice =  "English";

  getLanguageOption(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: [
              Container(
                child: Text("Choose Language",style: TextStyle(fontSize: 20),),
              ),
              Container(
                child: Card(

                  elevation: 3.0,
                  child: ListTile(title: Text("हिन्दी"),onTap: (){
                    setState(() {
                      languageChoice = "Hindi";
                    });
                    Navigator.pop(context);
                  }),
                ),
              ),

              Container(
                child: Card(
                  elevation: 3.0,
                  child: ListTile(title: Text("English"),onTap: (){
                    setState(() {
                      languageChoice = "English";
                    });
                    Navigator.pop(context);
                  }),
                ),
              ),
            ],
          ),
        )
      );
    });
  }


  @override
  void dispose() {
    textToSpeech.stop();
    super.dispose();
  }









  @override
  Widget build(BuildContext context) {
    String description,history,about;
    if(languageChoice == "Hindi" && (widget.cityData.descriptionHindi!=null || widget.cityData.historyHindi!=null && widget.cityData.aboutHindi!=null) ) {
      description = widget.cityData.descriptionHindi;
      history = widget.cityData.historyHindi;
      about = widget.cityData.aboutHindi;
    }
    else {
      description = widget.cityData.description;
      history = widget.cityData.history;
      about = widget.cityData.about;
    }


    Future speakShortDesc() async{
      if(clickedOverView == true) {
        await textToSpeech.speak(description);
        await textToSpeech.setPitch(1);
        await textToSpeech.setSpeechRate(0.8);
        await textToSpeech.setVoice("hi-in-x-hie-network");
      }
      else{
        await textToSpeech.stop();
      }

    }

    Future speakHistory() async{
      if(clickedHistory == true) {
        await textToSpeech.speak(history);
        await textToSpeech.setPitch(1);
        await textToSpeech.setSpeechRate(0.8);
        await textToSpeech.setVoice("hi-in-x-hie-network");
      }
      else{
        await textToSpeech.stop();
      }

    }

    Future speakAbout() async {
      if(clickedAbout == true) {
        await textToSpeech.speak(about);
        await textToSpeech.setPitch(1);
        await textToSpeech.setSpeechRate(0.8);
        await textToSpeech.setVoice("hi-in-x-hie-network");

      }
      else{
        await textToSpeech.stop();
      }

    }





    return  Scaffold(
      body: Container(
        //scroll view main
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          //main stack for app bar transparent///
          child: Stack(
            children: [
              //main Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //top stack . for slide show...
                  Stack(
                    children: [

                      Opacity(
                        opacity: 0.3,
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                      ),


                      Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        child: Carousel(
                          boxFit: BoxFit.cover,
                          dotSize: 3,
                          dotBgColor: Colors.transparent,
                          autoplayDuration:Duration(milliseconds:3000),
                          images: [
                            NetworkImage(widget.cityData.images[0]),
                            NetworkImage(widget.cityData.images[1]),
                            NetworkImage(widget.cityData.images[2]),
                            NetworkImage(widget.cityData.images[3]),
                            NetworkImage(widget.cityData.images.last)
                          ],
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        padding:EdgeInsets.all(15),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children : [
                              Text(
                                widget.cityData.city,
                                style: TextStyle(
                                    color: white,
                                    fontFamily: 'sf_pro_bold',
                                    fontSize: 23
                                ),
                              ),
                            ]
                        ),
                      ),
                    ],

                  ),
                  //top stack . for slide show...


                  SizedBox(height: 20,),

                  Card(
                    child:Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child:Column(
                        children: [
                          //overview head///
                          Container(
                              padding: EdgeInsets.only(left: 15,right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Overview",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'sf_pro_bold'
                                    ),
                                  ),

                                  IconButton(
                                    icon: Icon(Icons.translate,color: black,),
                                    onPressed:(){
                                      getLanguageOption(context);
                                    },

                                  ),

                                  IconButton(
                                    icon: Icon(clickedOverView ? Icons.stop : Icons.volume_up),
                                    onPressed: (){
                                      setState(() {
                                        if(clickedOverView == false) {
                                          clickedOverView = true;
                                        }
                                        else{
                                          clickedOverView = false;
                                        }
                                      });
                                      speakShortDesc();
                                    },
                                  ),
                                ],
                              )
                          ),
                          //overview head///

                          SizedBox(height: 10,),

                          //overview body short desc///
                          Container(
                            padding: EdgeInsets.only(left: 15,right: 15),
                            child: Text(
                              description,
                              style: TextStyle(
                                  fontFamily: "sf_pro_semi_bold",
                                  fontSize: 18
                              ),

                            ),

                          ),
                          //overview body short desc///
                        ],
                      )
                    )
                  ),


                  SizedBox(height: 15,),




                  //overview body history and about//
                  ExpansionTile(
                    title: Text("More"),
                    initiallyExpanded: false,
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 12),
                          child:Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15,right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "About",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'sf_pro_bold'
                                      ),
                                    ),

                                    IconButton(
                                      icon: Icon(clickedAbout ?Icons.stop : Icons.volume_up),
                                      onPressed: (){
                                        setState(() {
                                          if(clickedAbout == false) {
                                            clickedAbout = true;
                                          }
                                          else{
                                            clickedAbout = false;
                                          }
                                        });
                                        speakAbout();
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 15,right: 15),
                                child: Text(
                                  about,
                                  style: TextStyle(
                                      fontFamily: "sf_pro_semi_bold",
                                      fontSize: 18
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 15,right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "History",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'sf_pro_bold'
                                      ),
                                    ),

                                    IconButton(
                                      icon: Icon(clickedHistory ? Icons.stop : Icons.volume_up),
                                      onPressed: (){
                                        setState(() {
                                          if(clickedHistory == false) {
                                            clickedHistory = true;
                                          }
                                          else{
                                            clickedHistory = false;
                                          }
                                        });
                                        speakHistory();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15,right: 15),
                                child: Text(
                                  history,
                                  style: TextStyle(
                                      fontFamily: "sf_pro_semi_bold",
                                      fontSize: 18
                                  ),

                                ),
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                  //overview body history and about//


                  SizedBox(height: 10,),

                  OpenMap(
                    latitude: widget.cityData.latitude,
                    longitude: widget.cityData.longitude,
                    name: widget.cityData.city,
                  ),

                  SizedBox(height: 10,),
                  //Gallery .....
                  Container(
                      padding: EdgeInsets.only(left: 15,right: 15),
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'sf_pro_bold'
                        ),
                      )
                  ),

                  SizedBox(height: 10,),


                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(widget.cityData.images.length, (index) {
                          return Row(

                            children: [
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: (){
                                  print(index);
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(widget.cityData.images[index]),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          );
                        })

                    ),
                  ),


                  //Gallery ...../


                  SizedBox(height: 15,),






                  SizedBox(height: 15,),

                ],
              ),

              //app bar//
              Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              //app bar//
            ],
          ),
        ),
      ),
    );
  }
}
