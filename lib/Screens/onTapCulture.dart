import 'dart:collection';
import 'dart:ui';

import 'package:bhrammanbeta/Widgets/review_widget.dart';
import 'package:bhrammanbeta/data/data.dart';
import 'package:bhrammanbeta/data/review_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
// ignore: must_be_immutable



class OnTapCulture extends StatefulWidget {

  final Data activity;
  OnTapCulture(this.activity);


  @override
  _OnTapCultureState createState() => _OnTapCultureState();
}

class _OnTapCultureState extends State<OnTapCulture> {

  FlutterTts  textToSpeech = FlutterTts();

  bool clickedOverView = false;
  bool clickedAbout = false;
  bool clickedHistory = false;

  TextEditingController reviewController = TextEditingController();

  DatabaseService databaseService =  DatabaseService();

  var userRating = 0.0;

  var totalRating = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getReviews();
    super.initState();


  }

  @override
  void dispose() {
    textToSpeech.stop();
    super.dispose();
  }


  Widget showRating()  {


    return totalRating == 0 && reviewList == null ? Container(
      alignment: Alignment.center,
      child: SmoothStarRating(
        isReadOnly: true,
        rating: 4.0,
        starCount: 5,
        color: Colors.orange,
        size: 35,
      ),
    ) :
    Container(
      alignment: Alignment.center,
      child: SmoothStarRating(
        isReadOnly: true,
        rating: totalRating,
        starCount: 5,
        color: Colors.orange,
        size: 35,
      ),
    );





  }

  void setReview() async{

    dynamic uid = await AuthService.getUserIdSharedPref();
    dynamic userName = await AuthService.getUserNameSharePref();
    dynamic profilePic = await AuthService.getProfilePhotoSharedPref();
    if(reviewController.text != null) {
      await databaseService.saveUserReviewToFireStore(userId: uid,city:widget.activity.city,typeOfThing: widget.activity.typeOfThing,
          name: widget.activity.place,
          review: reviewController.text,
          userName:userName,
          profilePic:profilePic,
          userRating: userRating
      );




    }

    setState(() {
      reviewController.text = '';
    });


  }


  List<ReviewData> reviewList = new List();
  Map<dynamic,dynamic> data = new HashMap();

  void getReviews() async {
    await databaseService.getUserReviewsFromFireStore(typeOfThing: widget.activity.typeOfThing,
        city: widget.activity.city,name:widget.activity.place).then((value) {
      setState(() {
        if(value != null) {
          data = value;
          reviewList = data['reviewData'];
          totalRating  =data['totalRating'];
        }

      });
    });
  }


  getRating(BuildContext context) {
    return showDialog(context: context,builder: (context){

      return AlertDialog(
        content:  Container(
            height: 30,
            alignment: Alignment.center,
            child: SmoothStarRating(
              onRated:(value){
                setState(() {
                  userRating = value;
                });
              },
              starCount: 5,
              color: Colors.orange,
              size: 35,
            )
        ),
        actions: [
          MaterialButton(
            child: Text("Submit"),
            onPressed: (){
              setReview();
              getReviews();
              print(userRating);
              Navigator.pop(context);
            },

          )
        ],
      );

    });
  }


  String languageChoice = "English";

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

                      print("Hello");
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
  Widget build(BuildContext context) {

    String description,history,about;
    if(languageChoice == "Hindi" && (widget.activity.descriptionHindi!=null || widget.activity.historyHindi!=null && widget.activity.aboutHindi!=null) ) {
      description = widget.activity.descriptionHindi;
      history = widget.activity.historyHindi;
      about = widget.activity.aboutHindi;
    }
    else {
      description = widget.activity.shortdescription;
      history = widget.activity.history;
      about = widget.activity.about;
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



    return Scaffold(
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
                      Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        child: Carousel(
                          boxFit: BoxFit.cover,
                          dotSize: 3,
                          dotBgColor: Colors.transparent,
                          autoplayDuration:Duration(milliseconds:3000),
                          images: [
                            NetworkImage(widget.activity.images[0]),
                            NetworkImage(widget.activity.images[1]),
                            NetworkImage(widget.activity.images[2])
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
                                widget.activity.place,
                                style: TextStyle(
                                    color: white,
                                    fontFamily: 'sf_pro_bold',
                                    fontSize: 23
                                ),
                              ),
                              Text(
                                widget.activity.city,
                                style: TextStyle(
                                    color: white,
                                    fontFamily: 'sf_pro_bold',
                                    fontSize: 16
                                ),
                              )
                            ]
                        ),
                      ),
                    ],

                  ),
                  //top stack . for slide show...

                  SizedBox(height: 30,),

                  Card(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
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
                      ),
                    ),
                  ),





                  SizedBox(height: 15,),

                  //overview body history and about//
                  ExpansionTile(
                    title: Text("More"),
                    initiallyExpanded: false,
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              //overview head//
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
                            ]
                          ),
                        ),
                      ),

                    ],
                  ),
                  //overview body history and about//


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
                        children: List.generate(widget.activity.images.length, (index) {
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
                                        image: NetworkImage(widget.activity.images[index]),
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


                  Container(
                      padding: EdgeInsets.only(left: 15,right: 15),
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'sf_pro_bold'
                        ),
                      )
                  ),

                  SizedBox(height: 15,),




                  Container(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      children: <Widget>[
                        //---------------------------------
                        //this input field for commentss....
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: TextField(
                            controller: reviewController,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'sf_pro_regular'
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(

                                suffixIcon: IconButton(
                                  onPressed: () {
                                    getRating(context);
                                  },
                                  icon: Icon(Icons.send),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:grey),),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightGrey),
                                ),
                                hintText: 'What do you think about ${widget.activity.place}',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                )
                            ),
                          ),
                        ),
                        //---------------------------------

//                        this Row is used to show comment or rating...
                      ],
                    ),
                  ),

                  SizedBox(height: 15,),

                  showRating(),

                  SizedBox(height: 15,),


                  Container(
                    child: Column(
                        children: reviewList.length > 5 ?  List.generate(5, (index) {

                          return Reviews(profileImage: reviewList[index].profilePic,
                              time: reviewList[index].time, date:reviewList[index].date,rating: reviewList[index].currentRating, userName: reviewList[index].userName, review: reviewList[index].review);

                        }) : List.generate(reviewList.length, (index) {

                          return Reviews(profileImage: reviewList[index].profilePic,
                              time: reviewList[index].time,date:reviewList[index].date,rating : reviewList[index].currentRating, userName: reviewList[index].userName, review: reviewList[index].review);

                        })
                    ),
                  ),

                  SizedBox(height: 15,),

                  reviewList.length > 5 ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child:  OutlineButton(
                      onPressed: (){},
                      color: white,
                      highlightedBorderColor: black,
                      textColor: blueGreen,
                      child: Text("More Reviews",style: TextStyle(fontSize: 16,fontFamily: 'sf_pro_bold'),),
                    ),

                  ):Container(),




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
