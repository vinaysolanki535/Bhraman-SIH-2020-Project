import 'package:bhrammanbeta/Screens/activity_wall/activity_hashtags.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityWall extends StatefulWidget {
  @override
  _ActivityWallState createState() => _ActivityWallState();
}

class _ActivityWallState extends State<ActivityWall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: white,
         iconTheme: IconThemeData(
           color: black,
         ),
         title: Text("Activity Wall",style: TextStyle(color: black),),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ActivityHashTags(),
              ));
          },
          label: Text("Post"),
          icon: Icon(Icons.edit),
      ),

      body: Container(
         child: ListView(
           children: [
             Card(
               elevation: 3.0,
               child: Container(
                 padding: EdgeInsets.all(20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Announcements",
                       style: TextStyle(
                         fontSize: 18,
                         fontFamily: 'sf_pro_semi_bold',
                         color: Colors.red,
                       ),
                     ),
                    SizedBox(height: 10,),
                    StreamBuilder(
                      stream: Firestore.instance.collection("Activity").orderBy("timeStamp",descending: true).snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Column(
                            children: List.generate(snapshot.data.documents.length, (index) {
                              DocumentSnapshot  docDesc = snapshot.data.documents[index];
                               return  Column(
                                 children: [
                                   Text("- ${docDesc['Announcement']}",style: TextStyle(fontSize: 16),),
                                   SizedBox(height:10,),
                                 ],
                               );
                            }),
                          );
                        }
                        return Container();
                      }

                    ),





                   ],
                 ),
               ),
             ),

             StreamBuilder(
                 stream: Firestore.instance.collection("ActivityPosts").orderBy("timeStamp",descending: true).snapshots(),
                 builder: (context,snapshot){
                   if(snapshot.hasData){
                     return Column(
                       children: List.generate(snapshot.data.documents.length, (index) {
                         DocumentSnapshot  docDesc = snapshot.data.documents[index];
                         return docDesc['reported'] == null ?  Column(
                           children: [
                             Card(
                               elevation:4.0,
                               child: Container(
                                   padding: EdgeInsets.all(10),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: [
                                           CircleAvatar(
                                               radius: 15,
                                               backgroundImage: docDesc['profilePic'] !=null ?
                                               NetworkImage(docDesc['profilePic']) : AssetImage(
                                                   'assets/icons/profile_avatar.png'
                                               )
                                           ),

                                           SizedBox(width: 10,),
                                           Text(docDesc['userName'] !=null ? docDesc['userName'] : "Annonumous")

                                         ],
                                       ),
                                       SizedBox(height: 13.0,),

                                       Image(
                                         image: NetworkImage(
                                             docDesc['image']
                                         ),
                                       ),

                                       SizedBox(height: 5,),
                                       Text(docDesc['description'],style: TextStyle(fontSize: 18),),
                                       SizedBox(height: 5,),



                                       Container(
                                         width: MediaQuery.of(context).size.width,
                                         color: grey,
                                         height: 0.5,
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [

                                           IconButton(
                                             onPressed: (){},
                                             icon: Icon(Icons.thumb_up,color: Colors.grey,),
                                           ),

                                           IconButton(
                                             onPressed: (){},
                                             icon: Icon(Icons.thumb_down,color: Colors.grey,),
                                           ),

                                           FlatButton(
                                             onPressed: ()async{
                                                await Firestore.instance.collection("ActivityPosts")
                                                    .document(docDesc.documentID).updateData({
                                                   "reported" : true,
                                                });
                                             },
                                             child:Text("Report" ),
                                           ),
                                         ],
                                       ),


                                     ],
                                   )
                               ),
                             ),
                             Divider(height: 0.4,color: lightGrey,),
                             SizedBox(height: 20,)
                           ],
                         ) : Container();
                       }),
                     );
                   }
                   return Container();
                 }

             ),


           ],
         ),
      ),


    );
  }
}
