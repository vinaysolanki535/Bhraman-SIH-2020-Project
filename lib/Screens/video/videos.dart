import 'package:bhrammanbeta/Widgets/horizontal_card.dart';
import 'package:bhrammanbeta/Widgets/parts_headings.dart';
import 'package:bhrammanbeta/Widgets/videoList.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_upload_form.dart';
import 'play_video.dart';




class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 10,right: 10,bottom: 8,top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Videos',
                                style: TextStyle(
                                    fontFamily: 'sf_pro_bold',
                                    color: black,
                                    fontSize: 35),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    height: 250,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          bottomRight: const Radius.circular(25.0),
                          bottomLeft: const Radius.circular(25.0)),
                      boxShadow: [

                        BoxShadow(
                          offset: Offset(1.0,2.0),
                          blurRadius: 1.0,
                          color: grey,
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/video_img.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  PartsHeading(
                    headText: "Experiences",
                  ),


                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: StreamBuilder(
                          stream:Firestore.instance
                              .collection("Videos")
                              .orderBy("timeStamp", descending: true)
                              .snapshots(),
                          builder:  (context,snapshot) {
                            if(snapshot.data !=null) {
                              return Row(
                                children: List.generate(
                                    snapshot.data.documents.length, (index) {
                                  DocumentSnapshot videoData =
                                  snapshot.data.documents[index];
                                  return videoData['videoType'] == 'Experience' && videoData['status'] == true?

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(
                                        builder: (context) => PlayVideo(videoUrl: videoData['videoUrl'],
                                            titleVideo: videoData['videoTitle'], city: videoData['city'],
                                            userName: videoData['userName']),
                                      ));
                                    },
                                    child: HorizontalCard(
                                      height: 200.0,
                                      placeName: videoData['city'],
                                      thumbnailUrl: videoData['thumbImageUrl'],
                                    ),
                                  )
                                      : Container();

                                }),


                              );
                            }
                            return Container();
                          }
                      )
                  ),


                  SizedBox(height: 10,),


                  PartsHeading(
                    headText: "Food",
                  ),

                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("Videos")
                              .orderBy("timeStamp",descending: true)
                              .snapshots(),
                          builder:  (context,snapshots) {
                            if(snapshots.data !=null) {
                              return Row(
                                children: List.generate(
                                    snapshots.data.documents.length, (index) {
                                  DocumentSnapshot videoData =
                                  snapshots.data.documents[index];
                                  return videoData['videoType'] == 'Food'  && videoData['status'] == true ? GestureDetector(
                                    onTap: () {

                                      Navigator.push(context,MaterialPageRoute(
                                        builder: (context) => PlayVideo(videoUrl: videoData['videoUrl'],
                                            titleVideo: videoData['videoTitle'], city: videoData['city'],
                                            userName: videoData['userName']),
                                      ));

                                    },
                                    child: HorizontalCard(
                                      height: 200.0,
                                      placeName: videoData['city'],
                                      thumbnailUrl: videoData['thumbImageUrl'],
                                    ),
                                  ) : Container();
                                }),
                              );
                            }
                            return Container();
                          }
                      )
                  ),

                  SizedBox(height: 10,),

                  PartsHeading(
                    headText: "Monuments",
                  ),

                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("Videos")
                              .orderBy("timeStamp",descending: true)
                              .snapshots(),
                          builder:  (context,snapshots) {
                            if(snapshots.data !=null) {
                              return Row(
                                children: List.generate(
                                    snapshots.data.documents.length, (index) {
                                  DocumentSnapshot videoData =
                                  snapshots.data.documents[index];
                                  return videoData['videoType'] == 'Monuments' && videoData['status'] == true ?  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(
                                        builder: (context) => PlayVideo(videoUrl: videoData['videoUrl'],
                                          titleVideo: videoData['videoTitle'], city: videoData['city'],
                                          userName: videoData['userName'],  ),
                                      ));
                                    },
                                    child: HorizontalCard(
                                      height: 200.0,
                                      userName: videoData['userName'],
                                      placeName: videoData['city'],
                                      thumbnailUrl: videoData['thumbImageUrl'],
                                    ),
                                  ) : Container();
                                }),
                              );
                            }
                            return Container();
                          }
                      )
                  ),
                ]
              ),


                Positioned(
                  child: AppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),

              ],
            ),

          ],
        ),
     ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(
            Icons.add
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => VideoUploadForm(),
          ));
        },


      ),
    );
  }
}
