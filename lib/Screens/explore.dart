import 'file:///D:/FlutterProjects/bhramman_beta/bhramman_beta/lib/Screens/video/videos.dart';
import 'package:bhrammanbeta/Screens/activity_wall/activity_wall_main.dart';
import 'package:bhrammanbeta/Screens/live_stream.dart';
import 'package:bhrammanbeta/Screens/switch_section.dart';
import 'package:bhrammanbeta/Widgets/exploreCards.dart';
import 'package:bhrammanbeta/data/live_stream_data.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/discussion/discussion.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';

import 'chat_bot.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  DatabaseService databaseService = DatabaseService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text("Explore",style: TextStyle(color: black,
          fontSize: 24,
          fontFamily: 'sf_pro_bold',),),
      ),

      body: ListView(
        children: <Widget>[

          //one
          //---------------------------------------------------


          ExploreCard(
              image: 'assets/images/video_img.png',
              title: "Experiences" ,
              titleColor: black,
              widget: Container(),
              onTapWidget: Videos()
          ),


          //two
          //------------------------------------------

          ExploreCard(
              image: 'assets/images/chat_bot.png',
              title: "B-Guide" ,
              titleColor: black,
              widget: Container(),
              onTapWidget: ChatBot()
          ),


          ExploreCard(
              image: 'assets/images/livestream.png',
              title: "B-Stream" ,
              widget: Image.asset('assets/icons/live.gif',height: 30,),
              onTapWidget: LiveStream(),
              titleColor: Colors.black
          ),

          ExploreCard(
              image: 'assets/images/charcha.png',
              title: "Charcha" ,
              widget: Container(),
              onTapWidget: Discussion(),
              titleColor: Colors.black
          ),

          ExploreCard(
            image: "assets/images/switch.png",
            titleColor: black,
            title: "Switch",
            widget: Container(),
            onTapWidget: SwitchSection(),
          ),

          ExploreCard(
            image: "assets/images/activity_wall.png",
            titleColor: black,
            title: "#Activity Wall",
            widget: Container(),
            onTapWidget: ActivityWall(),
          )

        ],
      ),
    );
  }


}
