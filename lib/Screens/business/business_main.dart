import 'dart:ui';

import 'package:bhrammanbeta/Screens/business/add_art_shop_form.dart';
import 'package:bhrammanbeta/Screens/business/add_food_shop_form.dart';
import 'package:bhrammanbeta/Widgets/exploreCards.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

import '../login.dart';
import 'activity_shop_form.dart';


class Business extends StatefulWidget {
  @override
  _BusinessState createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: white,
         centerTitle: true,
         title: Text("Business",style: TextStyle(color: black,fontSize: 24,fontFamily: 'sf_pro_bold'),),
       ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 5,right: 5),
          child: Column(

            children: [

              ExploreCard(

                onTapWidget: FoodShopForm(),
                title: "ADD A FOOD SHOP",
                subTitle: '',
                widget: Container(),
                titleColor: black,
                image: 'assets/images/food_shop.png',
              ),

              ExploreCard(


                onTapWidget: ArtShopForm(),
                title: "Art and Craft",
                subTitle: '',
                widget: Container(),
                titleColor: black,
                image: 'assets/images/art_and_craft.png',
              ),

              ExploreCard(
                fit: BoxFit.fitHeight,
                onTapWidget: ActivityShopForm(),
                title: "Adventure Activities",
                subTitle: '',
                widget: Container(),
                titleColor: black,
                image: 'assets/images/adventure_activity.png',
              ),



            ],
          ),
        ),
      ),


    );
  }
}
