import 'package:bhrammanbeta/Widgets/open_map.dart';
import 'package:bhrammanbeta/Widgets/review_widget.dart';
import 'package:bhrammanbeta/data/best_places.dart';
import 'package:bhrammanbeta/data/review_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OnTapPlaces extends StatefulWidget {

  final BestPlacesData placesData;
  OnTapPlaces({this.placesData});

  @override
  _OnTapPlacesState createState() => _OnTapPlacesState();
}

class _OnTapPlacesState extends State<OnTapPlaces> {

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


  Widget showRating() {
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
      await databaseService.saveUserReviewToFireStore(userId: uid,city:widget.placesData.city,typeOfThing: "SpecialPlaces",
          name: widget.placesData.place,
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
  Map data;

  void getReviews() async {
    await databaseService.getUserReviewsFromFireStore(typeOfThing: "SpecialPlaces",
        city: widget.placesData.city,name:widget.placesData.place).then((value) {
      setState(() {
        if(value != null) {
          data = value;
          reviewList = data['reviewData'];
          totalRating  =data['totalRating'];
        }

      });
    });
  }

  String languageChoice = "English";

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
  Widget build(BuildContext context) {
    String shortDescription,history,about;
    if(languageChoice == "Hindi" &&(widget.placesData.shortDescriptionHindi!=null ||  widget.placesData.historyHindi!=null && widget.placesData.aboutHindi!=null)) {
      shortDescription = widget.placesData.shortDescriptionHindi;
      history = widget.placesData.historyHindi;
      about = widget.placesData.aboutHindi;
    }
    else {
      shortDescription = widget.placesData.shortDescription;
      history = widget.placesData.history;
      about = widget.placesData.about;
    }


    Future speakShortDesc() async{
      if(clickedOverView == true) {
        await textToSpeech.speak(shortDescription);
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
                            NetworkImage(widget.placesData.images[0]),
                            NetworkImage(widget.placesData.images[1]),
                            NetworkImage(widget.placesData.images[2])
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
                                widget.placesData.place,
                                style: TextStyle(
                                    color: white,
                                    fontFamily: 'sf_pro_bold',
                                    fontSize: 23
                                ),
                              ),
                              Text(
                                widget.placesData.city,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              shortDescription,
                              style: TextStyle(
                                  fontFamily: "sf_pro_semi_bold",
                                  fontSize: 18
                              ),

                            ),

                          ),
                          //overview body short desc///

                          SizedBox(height: 15,),


                          Container(
                              padding: EdgeInsets.only(left: 15,right: 15),
                              child: Text(
                                "Location",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'sf_pro_bold'
                                ),
                              ),
                          ),

                          SizedBox(height: 5,),

                          Container(
                            padding: EdgeInsets.only(left: 15,right: 15),
                            child: Text(
                              widget.placesData.location,
                              style: TextStyle(
                                  fontFamily: "sf_pro_semi_bold",
                                  fontSize: 16
                              ),

                            ),

                          ),
                        ],
                      ),
                    ),
                  ),








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
                            ),
                          )
                      )

                    ],
                  ),
                  //overview body history and about//


                  SizedBox(height: 5,),

                  OpenMap(
                    latitude: widget.placesData.latitude,
                    longitude: widget.placesData.longitude,
                    name: widget.placesData.place,
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
                        children: List.generate(widget.placesData.images.length, (index) {
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
                                        image: NetworkImage(widget.placesData.images[index]),
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
                                hintText: 'What do you think about ${widget.placesData.place}',
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
