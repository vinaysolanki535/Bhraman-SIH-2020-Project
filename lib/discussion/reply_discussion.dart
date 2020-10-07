import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyDiscussion extends StatefulWidget {

 final  String documentId, userName, userId,profilePhoto;
 final dynamic data;

 ReplyDiscussion({this.documentId,this.userName,this.userId,this.profilePhoto,this.data});

  @override
  _ReplyDiscussionState createState() => _ReplyDiscussionState();
}

class _ReplyDiscussionState extends State<ReplyDiscussion> {

  TextEditingController answerController = TextEditingController();

  saveAnswersToFirebase() async{
    await Firestore.instance.collection("Discussions").document(widget.documentId)
        .collection("Answers").document().setData({

      "userId" : widget.userId,
      "userName": widget.userName,
      "profilePhoto":widget.profilePhoto,
      "answer" : answerController.text,
      "timeStamp":Timestamp.now(),

    });

    await Firestore.instance.collection("Discussions").document(widget.documentId)
    .updateData({
      "answersCount" : widget.data['answersCount'] + 1,
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

        title: Text(
          "Answers",style: TextStyle(
            color: Colors.black,
            fontFamily: 'sf_pro_semi_bold'
          ),
        ),
      ),


      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [

            Flexible(
              child: ListView(
                children: [

                  Card(
                    elevation: 2.0,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: widget.data['profilePhoto'] !=null?
                                  NetworkImage(widget.data['profilePhoto']) : AssetImage('assets/icons/profile_avatar.png'),
                                ),

                                SizedBox(width: 10,),
                                Text(widget.data['userName']),
                              ],
                            ),

                            SizedBox(height: 13.0,),

                            Text(widget.data['question'],style: TextStyle(color:black,
                                fontFamily: 'sf_pro_semi_bold', fontSize: 20),),

                            Text(widget.data['description'],style: TextStyle(color:black,
                                fontFamily: 'sf_pro_regular', fontSize: 16),),


                            SizedBox(height: 30,),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: grey,
                              height: 0.5,
                            ),

                            Container(
                              padding: EdgeInsets.only(top: 5),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Text("Answers",style: TextStyle(color: Colors.black,
                                  fontSize: 16,fontFamily: 'normal_font' ),),
                            ),

                            Container(
                              padding: EdgeInsets.only(top: 5),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Text(widget.data['answersCount'].toString(), style: TextStyle(color: Colors.grey,
                                  fontSize: 12, fontFamily: 'normal_font' ),
                              ),
                            ),

                            SizedBox(height: 10,),

                          ],
                        )
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(5),
                    height: 40,
                    color:lightGrey,
                    child: Text(
                        "Best Answers",
                         style: TextStyle(
                           fontSize: 16,
                         ),
                    ),
                  ),


                  StreamBuilder(
                    stream: Firestore.instance.collection("Discussions").document(widget.documentId)
                    .collection("Answers").orderBy("timeStamp",descending: true).snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Column(
                            children: List.generate(snapshot.data.documents.length, (index){
                              DocumentSnapshot answersData = snapshot.data.documents[index];
                              return  snapshot.data!=null ?   Card(
                                  child : Container(

                                      padding: EdgeInsets.all(10),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundImage: answersData['profilePhoto'] !=null?
                                                NetworkImage(answersData['profilePhoto']) : AssetImage('assets/icons/profile_avatar.png'),
                                              ),

                                              SizedBox(width: 10,),
                                              Text(answersData['userName']),

                                            ],
                                          ),

                                          SizedBox(height: 13.0,),

                                          Text(answersData['answer'],style: TextStyle(color:black,
                                              fontFamily: 'sf_pro_regular', fontSize: 16),),

                                          SizedBox(height: 13.0,),
                                          Divider(
                                            height: 0.4,
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
                                  )
                              ) :
                              Container();

                            })
                        );
                      }
                      return Container();

                    }
                  )
                ],
              ),
            ),

           Divider(
             height: 0.5,
             color: blueGreen,
           ),

           Container(
             alignment: Alignment.bottomCenter,
             child: Row(
               children: [
                 Flexible(
                   child: TextField(
                     controller: answerController,
                     minLines: 1,
                     maxLines: 100,
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       hintText: "Write you answer"
                     ),
                   ),
                 ),
                 FlatButton(
                   onPressed: () async{
                     if(answerController.text.isNotEmpty){
                       await saveAnswersToFirebase();
                       setState(() {
                         answerController.text = "";
                       });
                     }
                   },
                   child: Text("Post"),
                 )
               ],
             ),
           ),

          ],
        ),
      ),


    );
  }
}
