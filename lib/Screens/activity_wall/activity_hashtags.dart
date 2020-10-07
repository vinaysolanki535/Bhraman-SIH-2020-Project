import 'package:bhrammanbeta/Screens/activity_wall/post_activity.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityHashTags extends StatefulWidget {
  @override
  _ActivityHashTagsState createState() => _ActivityHashTagsState();
}

class _ActivityHashTagsState extends State<ActivityHashTags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: black,
        ),
        title: Text("Trending #",style: TextStyle(color: black),),
      ),


      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Activity").orderBy("timeStamp",descending: true).snapshots(),

          builder: (context,snapshot){

            return  ListView.builder(

                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot docHashTag  = snapshot.data.documents[index];
                  return   Card(
                    elevation: 4.0,

                    color: index%2==0 ? Colors.green : Colors.lightBlue,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> PostActivity(hashTag: docHashTag['hashTag'],documentId : docHashTag.documentID),
                        ));
                      },
                      child: ListTile(
                        trailing: Icon(Icons.edit,color: white,),
                        title: Text(docHashTag['hashTag'],
                          style: TextStyle(color: Colors.white,fontSize: 18,
                              fontFamily: 'sf_pro_bold',letterSpacing: 0.6),
                        ),
                      ),
                    ),
                  );
                }
            );
          }

        )
      ),

    );



  }
}
