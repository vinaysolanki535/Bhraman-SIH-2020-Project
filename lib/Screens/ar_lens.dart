
import 'dart:io';


import 'package:bhrammanbeta/Screens/360_view.dart';
import 'package:bhrammanbeta/data/data.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panorama/panorama.dart';

class ArLens extends StatefulWidget {
  @override
  _ArLensState createState() => _ArLensState();
}

class _ArLensState extends State<ArLens> {

  File file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();


  }

  String _city;



  getLocation() async {

    try{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator().
      placemarkFromCoordinates(position.latitude,
          position.longitude,
          localeIdentifier:AutofillHints.location);

      String  city ="Delhi" , state;

      if(position == null || placemark == null) {
        setState(() {
          city = "Delhi";

        });
        return city;
      }

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
      });

    }
    catch(e){
      setState(() {
        _city = "Delhi";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text("Smart Lens" , style: TextStyle(color: black,fontSize: 24,fontFamily: 'sf_pro'),),
       ),
      floatingActionButton: FloatingActionButton(
         child: Icon(Icons.photo),
        onPressed: (){
           try {
             Navigator.push(context, MaterialPageRoute(
                builder :  (context) => ThreeSixtyView(imageSource: "Gallery",),
             ));
           } on Exception catch (e) {
             print("Exception caught");
           }
        },

      ),


      body : Container(
        padding: EdgeInsets.only(bottom: 10,right: 10, left: 10),
        child: StreamBuilder(
          stream: Firestore.instance.collection("Places").document("Delhi")
              .collection("360Images").orderBy("name").snapshots(),
            builder: (context,snapshot) {
            return !snapshot.hasData ? CircularProgressIndicator()  : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot imageData = snapshot.data.documents[index];
                  return Column(
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Card(
                            elevation: 3.0,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        ThreeSixtyView(imageUrl: imageData['imageUrl'],),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.25,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            imageData['imageUrl']),
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Container(
                                      child: Text(imageData['name'],
                                        style: TextStyle(fontSize: 20,),),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ]
                  );
                }
            );
          }
        ),
        ),
      );



  }



}
