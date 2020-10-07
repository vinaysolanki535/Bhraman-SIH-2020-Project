import 'dart:collection';

import 'package:bhrammanbeta/data/about_city_data.dart';
import 'package:bhrammanbeta/data/best_places.dart';
import 'package:bhrammanbeta/data/essence_data.dart';
import 'package:bhrammanbeta/data/food_data.dart';
import 'package:bhrammanbeta/data/live_stream_data.dart';
import 'package:bhrammanbeta/data/review_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  Firestore db = Firestore.instance;

  bool accountBusiness;
 Future<bool> getAccountType()async {
     return  await AuthService.getBusinessAccount();
  }

  Future<dynamic> createUserInDatabase({String email, String userId,String name,String profilePic,String phone}) async{
    try {
      await db.collection('Users').document(userId).setData({
        'email':email,
        'name':name,
        'profilePic':profilePic,
        'phone':phone,
         "accountType" : await getAccountType() ==  true ? "Business" : "normal",
      });
    }
    catch(e) {
       print(e.toString());
    }

  }


  Future<dynamic> getUserDataFromFireStore({String userId}) async{
     List<String> userData;

     await db.collection("Users").document(userId).get().then((value){

         userData.add(value.data['name']);
         userData.add(value.data['profilePic']);
         return userData;

     });

  }
  
   Future<dynamic> saveUserReviewToFireStore({String userId, String city,
     String typeOfThing, String name,String review,String userName,String profilePic,double userRating}) async{


    var time = DateTime.now();
    var hour = time.hour;
    var minute  = time.minute;
    var day = time.day.toString() + "/" + time.month.toString() + "/" + time.year.toString();

    try{
      await db.collection("Places").document(city).collection(typeOfThing).document(name).collection("Reviews").
      document().setData({
        "review" : review,
        "userName": userName,
        "timeStamp":Timestamp.now(),
        "time" : "$hour:$minute",
        "date":day,
        "profilePic" :profilePic,
        'rating' : userRating,
      });
    }
    catch(e) {
      print(e);
    }


  }


  Future <dynamic> getUserReviewsFromFireStore({String city, String typeOfThing,String name}) async{
    List<ReviewData> reviewData = new List();
    var totalRating = 0.0;
    Map<dynamic,dynamic> data = new HashMap();

      await db.collection("Places").document(city).collection(typeOfThing).document(name).collection("Reviews").orderBy("timeStamp",descending: true)
    .getDocuments().then((querySnapShots) {

        querySnapShots.documents.forEach((element) {

           totalRating = totalRating + element.data['rating'];

           reviewData.add(
             ReviewData(
               review: element.data['review'].toString(),
               userName: element.data['userName'].toString(),
               profilePic: element.data['profilePic'].toString(),
               date:element.data['date'].toString(),
               time: element.data['time'].toString(),
               rating: totalRating,
               currentRating:element.data['rating'],

             )
           );
        });
        totalRating = totalRating/querySnapShots.documents.length;

     });
    data = {"reviewData" : reviewData , "totalRating" : totalRating};

    return data;



  }
  
  Future<dynamic> getFoodDataFromFireStore({String city}) async{
    List<FoodData> foodData = new List();
    await db.collection("Places").document(city).collection("Food").getDocuments().then(
        (querySnapShots) {
            querySnapShots.documents.forEach((element) {

              List images = element.data['images'];
              Map longDesc = element.data['longDescription'];


                foodData.add(
                  FoodData(
                    city: element.data['city'],
                    foodName: element.data['foodName'],
                    images: images,
                    about: longDesc['aboutFood'],
                    famousPlace: longDesc['famousPlace'],
                    other: longDesc['other'],
                    shoreDescription:  element.data['shortDescription'],
                    shortDescriptionHindi: longDesc['shortDescriptionHindi'],
                    aboutHindi: longDesc['aboutFoodHindi'],
                    historyHindi: longDesc['famousPlaceHindi'],
                  )
                );
            });
        });

     return foodData;

  }


  Future<dynamic> getBestPlacesDataFireStore({String city}) async{
    List<BestPlacesData> placesData = new List();
    await db.collection("Places").document(city).collection("SpecialPlaces").getDocuments().then(
            (querySnapShots) {
          querySnapShots.documents.forEach((element) {

            List images = element.data['images'];
            Map longDesc = element.data['longDescription'];


            placesData.add(
                BestPlacesData(
                  city: element.data['city'],
                  place: element.data['placeName'],
                  images: images,
                  about: longDesc['about'],
                  history: longDesc['history'],
                  shortDescription:  element.data['shortDescription'],
                  latitude: element.data['latitude'],
                  longitude: element.data['longitude'],
                  location: element.data['location'],
                  shortDescriptionHindi: longDesc['shortDescriptionHindi'],
                  aboutHindi: longDesc['aboutHindi'],
                  historyHindi: longDesc['historyHindi'],



                )
            );
          });
        });

    return placesData;

  }

  Future<dynamic> getCityDataFirebaseFireStore({String city}) async{
    AboutCityData cityData;
    await db.collection("Places").document(city).get().then((value) {

       cityData = AboutCityData(
          city: value.data['city'],
          longitude: value.data['longitude'],
          latitude:  value.data['latitude'],
          description: value.data['shortDescription'],
           about: value.data['about'],
           images:  value.data['images'],
           history: value.data['history'],
           aboutHindi: value.data['aboutHindi'],
           historyHindi: value.data['historyHindi'],
           descriptionHindi: value.data['shortDescriptionHindi'],

       );

    });

    return cityData;
  }

  Future<dynamic> getEssenceDataFirebaseFireStore({String city}) async{
    List<EssenceData> essenceData = new List();
    await db.collection("Places").document(city).collection("IntangibleHeritage").getDocuments().then(
            (querySnapShots) {

              querySnapShots.documents.forEach((element) {

                essenceData.add(
                    EssenceData(
                      city: element.data['city'],
                      description: element.data['description'],
                      images: element.data['images'],
                      heritageName: element.data['heritageName'],
                      heritageNameHindi: element.data['heritageNameHindi'],
                      descriptionHindi: element.data['descriptionHindi']
                    )
                );
              });
            });

    return essenceData;



  }


  Future<void> saveLiveStreamDataToFirebase({String broadcastingId, String placeName, String city,
    String state,String userName,String userId}) async {

    try {
      await db.collection("LiveStreams").document(userId).setData({
        "broadcastingId":broadcastingId,
        "placeName":placeName,
        "state" : state,
        "userName":userName,
        "currentStatus":"online",
        "timeStamp" : Timestamp.now(),
      });
    }
    catch (e) {
      print(e);
    }

  }


  Future<dynamic> getLiveStreamDataFirebase() async {

    List<LiveStreamData> liveStreamData = new List();
    await db.collection("LiveStreams").orderBy("timeStamp",descending: true)
        .getDocuments().then((querySnapShots) {
          querySnapShots.documents.forEach((element) {
             liveStreamData.add(
               LiveStreamData(
                 broadCastingId: element.data['broadcastingId'],
                 currentStatus: element.data['currentState'],
                 placeName: element.data['placeName'],
                 state: element.data['state'],
                 userName: element.data['userName'],
                 timestamp: element.data['timeStamp'],
               )
             );
          });
    });

    return liveStreamData;
  }


  Future<void> saveVideoToFirebase({String userId,String type, String city,
    String state,String videoUrl, String thumbImageUrl,String videoTitle,String userName}) async {

   try{
     await db.collection("Videos").document().setData({

       "userId" : userId,
       "videoType": type,
       "videoUrl": videoUrl,
       "thumbImageUrl" : thumbImageUrl,
       'city': city,
       'state':state,
       'videoTitle' :videoTitle,
       'userName' : userName,
       "timeStamp":Timestamp.now(),

     });
   }
   catch(e) {
     print(e);
   }

  }

  Future<void> saveUserStoryToFirebase({String city,String state ,String userId , String storyTitle, String story,dynamic imageUrl}) async {
      Firestore.instance.collection("Story").document().setData({

        "city" : city,
        "description" : story,
        "HeritageName" : storyTitle,
        "images" : [storyTitle],
        "userId" : userId,
         "timeStamp" : Timestamp.now(),
        "state"  : state,

      });
  }


  Future<void> addShopToDatabase({String ownerName, String shopName, String shopAddress,
    String number, String email,String type, String city,String state, String famousThings,
    String shopPhoto,String passportPhoto,String aadhaarNumber, String gstIn, String licenseNumber  }) async{

    await db.collection("ShopRequests").document().setData({
        "shopType" : type,
          "ownerName" : ownerName,
          "shopName" : shopName,
          "shopAddress" : shopAddress,
          "number" : number,
          "email" : email,
          "city" : city,
          "state" : state,
          "famousThings" : famousThings,
          "timeStamp" : Timestamp.now(),
          "status"  : "notApproved",
          "passportPhoto" : passportPhoto,
          "shopPhoto" : shopPhoto,
          "aadharNumber" : aadhaarNumber,
          "gstIn" : gstIn,
          "licenseNumber" : licenseNumber,

     });

  }

}

