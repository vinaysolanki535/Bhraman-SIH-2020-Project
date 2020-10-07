import 'package:bhrammanbeta/Widgets/review_widget.dart';
import 'package:bhrammanbeta/data/review_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OnTapBusiness extends StatefulWidget {

  final String image,number,email,address,ownerName,shopName,city,famousThings,documentId;
  OnTapBusiness({this.email,this.documentId,this.image,this.number,this.address,this.ownerName,this.shopName,this.famousThings,this.city,});

  @override
  _OnTapBusinessState createState() => _OnTapBusinessState();
}

class _OnTapBusinessState extends State<OnTapBusiness> {

  var userRating = 0.0;

  var totalRating = 0.0;

  Widget showRating()  {

//
//    return totalRating == 0 && reviewList == null ? Container(
//      alignment: Alignment.center,
//      child: SmoothStarRating(
//        isReadOnly: true,
//        rating: 4.0,
//        starCount: 5,
//        color: Colors.orange,
//        size: 35,
//      ),
//    ) :
   return  Container(
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

  void setReview() async {
    dynamic uid = await AuthService.getUserIdSharedPref();
    dynamic userName = await AuthService.getUserNameSharePref();
    dynamic profilePic = await AuthService.getProfilePhotoSharedPref();
//    if(reviewController.text != null) {
//      await databaseService.saveUserReviewToFireStore(userId: uid,city:widget.essenceData.city,typeOfThing: "IntangibleHeritage",
//          name: widget.essenceData.heritageName,
//          review: reviewController.text,
//          userName:userName,
//          profilePic:profilePic,
//          userRating: userRating
//      );
//    }
//    setState(() {
//      reviewController.text = '';
//    });
//
  }


    List<ReviewData> reviewList = new List();
    Map<dynamic, dynamic> data;
    TextEditingController reviewController = TextEditingController();

    DatabaseService databaseService = DatabaseService();


//  void getReviews() async {
//    await databaseService.getUserReviewsFromFireStore(typeOfThing: "ShopRequests",
//        city: widget.docuementId,name:widget.essenceData.heritageName).then((value) {
//      setState(() {
//        if(value != null) {
//          data = value;
//          reviewList = data['reviewData'];
//          totalRating  =data['totalRating'];
//        }
//      });
//    });
//  }


    getRating(BuildContext context) {
      return showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Container(
              height: 30,
              alignment: Alignment.center,
              child: SmoothStarRating(
                onRated: (value) {
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
              onPressed: () {
                setReview();

                print(userRating);
                Navigator.pop(context);
              },

            )
          ],
        );
      });
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          //scroll view main
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.60,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.image),
                          ),
                        ),


                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.60,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.shopName,
                                  style: TextStyle(
                                      color: white,
                                      fontFamily: 'sf_pro_bold',
                                      fontSize: 23
                                  ),
                                ),
                                Text(
                                  widget.city,
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

                    SizedBox(height: 20,),


                    Card(

                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //overview head///
                            Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  "Famous For",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'sf_pro_bold'
                                  ),
                                )
                            ),
                            //overview head///

                            SizedBox(height: 10,),

                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                widget.famousThings,
                                style: TextStyle(
                                    fontFamily: "sf_pro_semi_bold",
                                    fontSize: 18
                                ),

                              ),
                            ),

                            Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  "Address",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'sf_pro_bold'
                                  ),
                                )
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                widget.address,
                                style: TextStyle(
                                    fontFamily: "sf_pro_semi_bold",
                                    fontSize: 18
                                ),

                              ),
                            ),


                            Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  "Owner Name",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'sf_pro_bold'
                                  ),
                                )
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                widget.ownerName,
                                style: TextStyle(
                                    fontFamily: "sf_pro_semi_bold",
                                    fontSize: 18
                                ),

                              ),
                            ),


                            Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  "Contact Details",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'sf_pro_bold'
                                  ),
                                )
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                widget.number,
                                style: TextStyle(
                                    fontFamily: "sf_pro_semi_bold",
                                    fontSize: 18
                                ),

                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                widget.email,
                                style: TextStyle(
                                    fontFamily: "sf_pro_semi_bold",
                                    fontSize: 18
                                ),

                              ),
                            ),


                          ],
                        ),
                      ),

                    ),


                    SizedBox(height: 15,),


                    //Gallery ...../

                    Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
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
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          //---------------------------------
                          //this input field for commentss....
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 2.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: grey),),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: lightGrey),
                                  ),
                                  hintText: 'What do you think about ${widget
                                      .shopName}',
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
                          children: reviewList.length > 5 ? List.generate(
                              5, (index) {
                            return Reviews(
                                profileImage: reviewList[index].profilePic,
                                time: reviewList[index].time,
                                date: reviewList[index].date,
                                rating: reviewList[index].currentRating,
                                userName: reviewList[index].userName,
                                review: reviewList[index].review);
                          }) : List.generate(reviewList.length, (index) {
                            return Reviews(
                                profileImage: reviewList[index].profilePic,
                                time: reviewList[index].time,
                                date: reviewList[index].date,
                                rating: reviewList[index].currentRating,
                                userName: reviewList[index].userName,
                                review: reviewList[index].review);
                          })
                      ),
                    ),

                    SizedBox(height: 15,),

                    reviewList.length > 5 ? Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 50,
                      child: OutlineButton(
                        onPressed: () {},
                        color: white,
                        highlightedBorderColor: black,
                        textColor: blueGreen,
                        child: Text("More Reviews", style: TextStyle(
                            fontSize: 16, fontFamily: 'sf_pro_bold'),),
                      ),

                    ) : Container(),


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
