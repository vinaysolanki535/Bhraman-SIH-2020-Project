

import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/discussion/raise_discussion.dart';
import 'package:bhrammanbeta/discussion/reply_discussion.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Discussion extends StatefulWidget {
  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {


  @override
  initState() {
    super.initState();
     getUserDataFromLocal();
  }

  String profilePhoto, userName, userId;

  getUserDataFromLocal() async{
    await AuthService.getProfilePhotoSharedPref().then((value) {
      if(value!=null) {
         setState(() {
           profilePhoto = value;
         });
      }
    });
    await AuthService.getUserIdSharedPref().then((value) {
       if(value!=null){
         userId =  value;
       }
    });
    await AuthService.getUserNameSharePref().then((value){
      if(value!=null) {
        setState(() {
          userName = value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Discussions",style: TextStyle(color: Colors.black, fontFamily: 'sf_pro_semi_bold'),),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => RaiseDiscussion(userName : userName, userId: userId,profilePhoto : profilePhoto),
              ));
            },
            icon: Icon(Icons.edit,color: Colors.black,),
          ),
        ],
      ),

     floatingActionButton: FloatingActionButton.extended(
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(
             builder: (context) => RaiseDiscussion(userName : userName, userId: userId,profilePhoto : profilePhoto),
           ));
         },
         label: Text("Post"),
         icon:Icon( Icons.edit,)
     ),


     body: Container(
       padding: EdgeInsets.all(10),
       color: Colors.white70,
       child: StreamBuilder(
         stream: Firestore.instance.collection("Discussions").orderBy("timeStamp",descending: true)
             .snapshots(),

       builder: (context, snapshot){
           if(snapshot.data!=null) {


             return ListView.builder(

               itemCount: snapshot.data.documents.length,
               itemBuilder: (context,index){
                 DocumentSnapshot dataDiscuss = snapshot.data.documents[index];
                 return  Column(
                   children: [
                     Card(
                       elevation:4.0,
                       child: InkWell(
                         borderRadius: BorderRadius.circular(5),
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) => ReplyDiscussion(
                               userName: userName,
                               userId: userId,
                               profilePhoto: profilePhoto,
                               documentId: dataDiscuss.documentID,
                               data : dataDiscuss,
                             ),
                           ));
                         },
                         child: Container(
                             padding: EdgeInsets.all(10),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     CircleAvatar(
                                       radius: 15,
                                       backgroundImage: dataDiscuss['profilePhoto'] !=null ?
                                       NetworkImage(dataDiscuss['profilePhoto']) : AssetImage(
                                         'assets/icons/profile_avatar.png'
                                       )
                                     ),

                                     SizedBox(width: 10,),
                                     Text(dataDiscuss['userName'] !=null ? dataDiscuss['userName'] : "Annonumous")

                                   ],
                                 ),
                                 SizedBox(height: 13.0,),
                                 Text(dataDiscuss['question'],style: TextStyle(color:black,
                                     fontFamily: 'sf_pro_semi_bold', fontSize: 20),),
                                 SizedBox(height: 5,),

                                 Text(dataDiscuss['description'],style: TextStyle(color:black,
                                     fontFamily: 'sf_pro_semi_bold', fontSize: 20),),


                                 Container(
                                   width: MediaQuery.of(context).size.width,
                                   color: grey,
                                   height: 0.5,
                                 ),

                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     FlatButton(
                                       onPressed: (){},
                                       child:Text("Up Vote" ),
                                     ),

                                     IconButton(
                                       onPressed: (){},
                                       icon: Icon(Icons.thumb_up),
                                     ),

                                     IconButton(
                                       onPressed: (){},
                                       icon: Icon(Icons.thumb_down),
                                     ),

                                     FlatButton(
                                       onPressed: (){},
                                       child:Text("Down Vote" ),
                                     ),
                                   ],
                                 ),


                               ],
                             )
                         ),
                       ),
                     ),
                     Divider(height: 0.4,color: lightGrey,),
                     SizedBox(height: 20,)
                   ],
                 );
               },
             );
           }else {
             return Container();
           }
       }


       )
     ),


    );
  }
}
