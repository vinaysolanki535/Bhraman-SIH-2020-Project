import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {

  final feedBackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("FeedBack"),

      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
        if(!_formKey.currentState.validate())   {


        }
        else{
          await Firestore.instance.collection("FeedBacks").document().setData({
            "Feedback" : feedBackController.text,
            "timeStamp" : Timestamp.now(),
          });
          Navigator.pop(context);
        }

      }, label:Text("Post FeedBack")),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return("Field should not be empty");
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 30,
                style: TextStyle(
                  fontSize: 18
                ),
                controller: feedBackController,
                decoration: InputDecoration(
                  hintText: "Please give your feedback",
                ),
              )
            ],
          ),
        )
      ),

    );
  }
}
