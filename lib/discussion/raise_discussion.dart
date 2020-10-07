import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RaiseDiscussion extends StatefulWidget {

  final String userName;
  final String  userId;
  final String profilePhoto;

  RaiseDiscussion({this.userName, this.userId, this.profilePhoto});

  @override
  _RaiseDiscussionState createState() => _RaiseDiscussionState();
}

class _RaiseDiscussionState extends State<RaiseDiscussion> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  initState(){
    super.initState();
  }

  addDiscussionToDatabase() async{
    await Firestore.instance.collection("Discussions").document().setData({

       "userName" : widget.userName,
       "userId" : widget.userId,
       "timeStamp" : Timestamp.now(),
        "question" : titleController.text,
       "description"  : descriptionController.text,
       "profilePhoto" : widget.profilePhoto,

     });
  }

  savePost() async{
    if(_formKey.currentState.validate()){
      await addDiscussionToDatabase();
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Text Post",style: TextStyle(color: Colors.black, fontFamily: 'sf_pro_semi_bold'),),
        actions: [
          FlatButton(
              onPressed: ()async {await savePost();},
              child: Text("Post",style: TextStyle(color: black,fontSize: 16.5),),

          )
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value){
                      if(value.isEmpty){
                        return "The field should not be empty";
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    decoration: InputDecoration(
                      hintText: "Write an Interesting Question"
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    child: TextField(
                      controller: descriptionController,
                      minLines: 1,
                      maxLines: 200,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                          hintText: "Description of the post (optional)"
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );



  }
}
