import 'package:bhrammanbeta/Screens/about_city.dart';
import 'package:bhrammanbeta/Screens/business/BusinessShops.dart';
import 'package:bhrammanbeta/Screens/food.dart';
import 'package:bhrammanbeta/Widgets/culture_home.dart';
import 'package:bhrammanbeta/Widgets/in_place_cards.dart';
import 'package:bhrammanbeta/Widgets/monuments.dart';
import 'package:bhrammanbeta/Widgets/searchbar_home.dart';
import 'package:bhrammanbeta/Widgets/topof_home.dart';
import 'package:bhrammanbeta/add_hom_form/add_culture.dart';
import 'package:bhrammanbeta/add_hom_form/add_monument.dart';
import 'package:bhrammanbeta/data/about_city_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import '../data/data.dart';
import 'package:flutter/widgets.dart';

import 'best_places.dart';
import 'login.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {

  String city;
  HomePage({this.city});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseService data = new DatabaseService();
  AuthService _authService = new AuthService();

  String topImageUrl;


  String _city ;
  String _state;

  bool loading = true;

  dynamic lat,long;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     getFullData();
  }



  getLocation() async {

     try{
       Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
       List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude,localeIdentifier:AutofillHints.location);

       String  city ="Delhi" , state;

       if(position == null || placemark == null) {
         setState(() {
           city = "Delhi";

         });
         return city;
       }

       setState(() {
         lat = position.latitude;
         long = position.longitude;
       });

       if(placemark[0].subAdministrativeArea == 'Dewas'){
         city = "Indore";
         state = "Madhya Pradesh";
       }
       else if(placemark[0].subAdministrativeArea == "Ghaziabad") {
         city = "Delhi";
         state = "New Delhi";
       }
       else if(placemark[0].subAdministrativeArea == 'Jaipur') {
         city = "Jaipur";
         state ="Rajasthan";
       }
       else if(placemark[0].subAdministrativeArea == 'Indore') {
         city = "Indore";
         state = "Madhya Pradesh";
       }
       else if(placemark[0].subAdministrativeArea == 'Satna' ||
           placemark[0].subAdministrativeArea == 'Bina') {
         city = "Indore";
         state = "Madhya Pradesh";
       }
       else if(placemark[0].administrativeArea == 'Rajasthan') {
         city = "Jaipur";
         state = "Rajasthan";
       }
       else {
         city = "Delhi";
         state = "New Delhi";
       }

       setState(() {
         _city =  city;
         _state = state;

       });

     }
     catch(e){
       setState(() {
         _city = "Delhi";
       });
     }
  }


  List searchData;

  getSearchData() async {
    List searchPlaces = new List();
    await Firestore.instance.collection("Places").getDocuments().then((value) {

      value.documents.forEach((element) {

         searchPlaces.add(element.data['city']);

      });

    });
    setState(() {
      searchData = searchPlaces;
    });

  }

  String profilePhoto;

  getProfileImage() async {
    await AuthService.getProfilePhotoSharedPref().then((value) {
       if (value!=null) {
         setState(() {
           profilePhoto = value;
         });
       }
    });
  }



  getFullData() async {
    setState(() {
      loading  = true;
    });
    await getProfileImage();
    await getSearchData();
    await getLocation();
    await getImage();
    await getMonuments();
    await getCulture();
    await getFestivals();
    await getCityData();
    setState(() {
      loading  = false;
    });
  }

  DatabaseService databaseService = DatabaseService();

  AboutCityData cityData;

  getCityData() async{
    await databaseService.getCityDataFirebaseFireStore(city: widget.city == null ?  _city : widget.city).then((value) {
      if(value!=null) {
        setState(() {
          cityData =  value;
        });
      }

    });
  }


  List <Data> monuments = new List();
   getMonuments() async {
    await Firestore.instance.collection("Places").document(widget.city == null ?  _city : widget.city).collection("Monuments")
        .getDocuments().then((querySnapshot) {

       querySnapshot.documents.forEach((element) {

        List images = element.data['images'];
        Map longDesc = element.data['longDescription'];

        monuments.add(
            Data(
                imageUrl: images[0],
                place: element.data['monumentName'].toString(),
                images: images,
                location: element.data['location'].toString(),
                shortdescription: element.data['shortDescription'].toString(),
                history: longDesc['history'].toString(),
                entryFee: element.data['entryFee'],
                about: longDesc['aboutThePlace'].toString(),
                city: element.data['city'].toString(),
                latitude: element.data['latitude'],
                longitude: element.data['longitude'],
                aboutHindi: longDesc['aboutThePlaceHindi'],
                descriptionHindi: longDesc['shortDescriptionHindi'],
                historyHindi: longDesc['historyHindi'],
            )
        );
      });
    });
  }


  List <Data> cultureAndFestival = new List();
 getCulture() async {
    await Firestore.instance.collection("Places").document(widget.city == null ?  _city : widget.city).collection("Culture")
        .getDocuments().then((querySnapshot) {

      querySnapshot.documents.forEach((element) {
        List images = element.data['images'];
        Map longDesc = element.data['longDescription'];

        cultureAndFestival.add(
            Data(
              imageUrl: images[0],
              place: element.data['cultureName'].toString(),
              images: images,
              shortdescription: element.data['shortDescription'].toString(),
              history: longDesc['history'].toString(),
              about: longDesc['about'].toString(),
              aboutHindi: longDesc['aboutHindi'].toString(),
              historyHindi: longDesc['historyHindi'].toString(),
              descriptionHindi: longDesc['shortDescriptionHindi'] ,
              typeOfThing: "Culture",
              city: element.data['city'].toString(),
              latitude: element.data['latitude'],
              longitude: element.data['longitude'],
            )
        );
      });
    });
  }


  getFestivals() async {
    await Firestore.instance.collection("Places").document(widget.city == null ?  _city : widget.city).collection("Festivals")
        .getDocuments().then((querySnapshot) {

      querySnapshot.documents.forEach((element) {
        List images = element.data['images'];
        Map longDesc = element.data['longDescription'];

        cultureAndFestival.add(
            Data(
              imageUrl: images[0],
              place: element.data['festivalName'].toString(),
              images: images,
              typeOfThing: "Festival",
              shortdescription: element.data['shortDescription'].toString(),
              historyHindi: longDesc['historyHindi'],
              aboutHindi: longDesc['aboutHindi'],
              descriptionHindi: longDesc['shortDescriptionHindi'],
              history: longDesc['history'].toString(),
              about: longDesc['about'].toString(),
              city: element.data['city'].toString(),
            )
        );
      });
    });
  }

  getImage() async{
     await Firestore.instance.collection("Places").document(widget.city == null ?
     _city : widget.city).get().then((value)
     {
       if(value!=null){
         setState(() {
           topImageUrl = value.data['mainImage'];
         });
       }

     });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 22.0),
          shape: CircleBorder(),
          overlayColor: Colors.black26,

          children: [
            SpeedDialChild(
                child: Icon(Icons.blur_circular),
                backgroundColor: Colors.red,
                label: 'Add Culture',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) => AddCultureForm()
                   )
                  );
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.monochrome_photos),
                backgroundColor: Colors.blue,
                label: 'Add Monument',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: ()  {
                  Navigator.push(context,MaterialPageRoute(
                      builder: (context) => AddMonumentsForm()
                    )
                  );
                }
            ),
          ],

        ),



        body: loading == false ?  Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: <Widget>[
                //staring text
                TopOfHome(topImageUrl: topImageUrl,profileImageUrl: profilePhoto,cityName: widget.city == null  ?  _city : widget.city,),
                //search bar
                widget.city == null ? SearchBarHome(searchList : searchData) : Container(),
                SizedBox(height: 20,),

                //text of near by u
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Monuments',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'sf_pro_bold',
                            color: black),
                      ),
                    ],
                  ),
                ),
                //near by u .....

               ForYou(monuments),

                SizedBox(height: 30.0,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Regional Culture',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'sf_pro_bold',
                            color: black),
                      ),
                    ],
                  ),
                ),

                Culture(cultureAndFestival),
                SizedBox(height: 30.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'In Place',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'sf_pro_bold',
                            color: black),
                      ),

                    ],
                  ),
                ),

                InPlaceCard(imageUrl:'assets/images/food.webp', name: "Food",onTapWidget: Food(city : widget.city == null ?  _city : widget.city),),

                InPlaceCard(imageUrl:'assets/images/best_place.jpg', name: "Core",onTapWidget: BestPlaces(city: widget.city == null?  _city : widget.city),),

                InPlaceCard(imageUrl:'assets/images/about.jpg', name: "About",onTapWidget: AboutCity(city:widget.city == null ?  _city : widget.city,cityData: cityData,),),

                InPlaceCard(imageUrl:'assets/images/business.jpg', name: "Arcade",
                  onTapWidget:BusinessShops()),


                SizedBox(height: 12.0,),



              ],
            ),
          ),
        ),
      )
          : Shimmer.fromColors(
           baseColor: grey, highlightColor: lightGrey,
           child: ShimmerLayout(),
        )
    );
  }
}

class ShimmerLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double containerWidth = 200;
    double containerHeight = 15;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              return Container(
                child: Column(
                  children:[
                    Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: containerHeight,
                            width: containerWidth * 0.75,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ]
                  ),
                  SizedBox(height: 10,),

                 ]
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
