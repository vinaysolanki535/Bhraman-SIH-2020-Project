import 'file:///D:/FlutterProjects/bhramman_beta/bhramman_beta/lib/Screens/video/videos.dart';
import 'package:bhrammanbeta/Widgets/horizontal_card.dart';
import 'package:bhrammanbeta/Widgets/videoList.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayVideo extends StatefulWidget {

  final String videoUrl, userName, city, state, typeOfVideo, titleVideo;

  PlayVideo({this.videoUrl,this.userName,this.city,this.typeOfVideo,this.state,this.titleVideo});

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [

              Container(
                child: VideoList(
                  videoPlayerController: VideoPlayerController.network(widget.videoUrl),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.centerLeft,
                  child : Text(widget.titleVideo,
                  style: TextStyle(color: black,
                  fontFamily: 'sf_pro_bold',fontSize: 18),)
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 30,right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        children : [
                          Icon(Icons.thumb_up,color: grey,),
                          Text("Like")
                      ]
                    ),

                    Column(
                        children : [
                          Icon(Icons.thumb_down,color: grey,),
                          Text("Dislike")
                        ]
                    ),

                    Column(
                        children : [
                          Text('2000'),
                          Text("Views")
                        ]
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                height: 0.5,
                color: grey,
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(

                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/manone.png'),
                    ),
                    SizedBox(width: 40,),
                    Text(widget.userName,
                      style: TextStyle(
                          color: black,
                          fontFamily: 'normal_font',
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                height: 0.5,
                color: grey,
              ),


            StreamBuilder(
              stream: Firestore.instance.collection("Videos")
              .orderBy("timeStamp",descending: true)
              .snapshots(),
              builder: (context, snapshots) {
                if(snapshots.data != null) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(snapshots.data.documents.length, (index){
                        DocumentSnapshot videoData = snapshots.data.documents[index];
                        return videoData['videoUrl'] != widget.videoUrl ?  Column(
                          children : [

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                   builder: (context) => PlayVideo(videoUrl: videoData['videoUrl'],titleVideo: videoData['videoTitle'], city: videoData['city'],
                                       userName: videoData['userName'])
                                ));
                              },
                              child: HorizontalCard(
                              placeName: videoData['city'],
                              userName: videoData['userName'],
                              thumbnailUrl: videoData['thumbImageUrl'],
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              ),
                            ),


                          SizedBox(height: 10,)
                         ]
                        ) :Container();
                      })
                  );
                }
                return Container();
              },

            )


            ],
          ),
        ),
      ),
    );
  }
}
