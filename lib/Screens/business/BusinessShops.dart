import 'package:bhrammanbeta/Screens/business/on_tap_business.dart';
import 'package:bhrammanbeta/Screens/video/play_video.dart';
import 'package:bhrammanbeta/Screens/video/video_upload_form.dart';
import 'package:bhrammanbeta/Widgets/horizontal_card.dart';
import 'package:bhrammanbeta/Widgets/parts_headings.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BusinessShops extends StatefulWidget {
  @override
  _BusinessShopsState createState() => _BusinessShopsState();
}

class _BusinessShopsState extends State<BusinessShops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Other Activities"),
      ),

      body: Container(
         child: ListView(
           children: [
             Column(
               children: [
                 PartsHeading(
                   headText: "Food Shops",
                 ),

                 Container(
                   child: StreamBuilder(
                       stream: Firestore.instance.collection("ShopRequests").snapshots(),
                       builder: (context,snapshot){
                         if(!snapshot.hasData) {
                           return CircularProgressIndicator();
                         }
                         return SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: List.generate(snapshot.data.documents.length, (index) {
                               DocumentSnapshot shopDoc = snapshot.data.documents[index];
                               return shopDoc['shopType'] == 'FoodShop' &&  shopDoc['status'] == 'approved' ? GestureDetector(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => OnTapBusiness(
                                        city: shopDoc['city'],shopName: shopDoc['shopName'],
                                        address: shopDoc['shopAddress'],number: shopDoc['number'],
                                        email: shopDoc['email'],ownerName: shopDoc['ownerName'],
                                        image: shopDoc['shopPhoto'],famousThings: shopDoc['famousThings'],
                                      )
                                   ));
                                 },
                                 child: HorizontalCard(
                                   height: 200.0,
                                   placeName:shopDoc['shopName'],
                                   thumbnailUrl: shopDoc['shopPhoto'],
                                 ),
                               ) : Container();
                             }),
                           ),
                         );
                       }

                   ),
                 ),

                 PartsHeading(
                   headText: "Art and Craft Shops",
                 ),


                 Container(
                   child: StreamBuilder(
                       stream: Firestore.instance.collection("ShopRequests").snapshots(),
                       builder: (context,snapshot){
                         if(!snapshot.hasData) {
                           return CircularProgressIndicator();
                         }
                         return SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: List.generate(snapshot.data.documents.length, (index) {
                               DocumentSnapshot shopDoc = snapshot.data.documents[index];
                               return shopDoc['shopType'] == 'ArtShop' && shopDoc['status'] == 'approved' ? GestureDetector(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => OnTapBusiness(
                                         city: shopDoc['city'],shopName: shopDoc['shopName'],
                                         address: shopDoc['shopAddress'],number: shopDoc['number'],
                                         email: shopDoc['email'],ownerName: shopDoc['ownerName'],
                                         image: shopDoc['shopPhoto'],famousThings: shopDoc['famousThings'],
                                       )
                                   ));
                                 },
                                 child: HorizontalCard(
                                   height: 200.0,
                                   placeName:shopDoc['shopName'],
                                   thumbnailUrl: shopDoc['shopPhoto'],
                                 ),
                               ) : Container();
                             }),
                           ),
                         );
                       }
                   ),
                 ),

                 PartsHeading(
                   headText: "Adventures",
                 ),

                 Container(
                   child: StreamBuilder(
                       stream: Firestore.instance.collection("ShopRequests").snapshots(),
                       builder: (context,snapshot){
                         if(!snapshot.hasData) {
                           return CircularProgressIndicator();
                         }
                         return SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: List.generate(snapshot.data.documents.length, (index) {
                               DocumentSnapshot shopDoc = snapshot.data.documents[index];
                               return shopDoc['shopType'] == 'Adventure' &&  shopDoc['status'] == 'approved'? GestureDetector(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => OnTapBusiness(
                                         city: shopDoc['city'],shopName: shopDoc['shopName'],
                                         address: shopDoc['shopAddress'],number: shopDoc['number'],
                                         email: shopDoc['email'],ownerName: shopDoc['ownerName'],
                                         image: shopDoc['shopPhoto'],famousThings: shopDoc['famousThings'],
                                       )
                                    )
                                   );
                                 },
                                 child: HorizontalCard(
                                   height: 200.0,
                                   placeName:shopDoc['shopName'],
                                   thumbnailUrl: shopDoc['shopPhoto'],
                                 ),
                               ) : Container();
                             }),
                           ),
                         );
                       }
                   ),
                 ),
               ],
             ),
           ],
         ),
      ),

    );
  }
}