import 'package:bhrammanbeta/Screens/add_photos.dart';
import 'package:bhrammanbeta/Screens/before_login/before_login.dart';
import 'package:bhrammanbeta/Screens/edit_profile.dart';
import 'package:bhrammanbeta/Screens/essence/add_stories_form.dart';
import 'package:bhrammanbeta/Screens/feedback_page.dart';
import 'package:bhrammanbeta/Screens/live_stream/live_stream_form.dart';
import 'package:bhrammanbeta/Screens/video/video_upload_form.dart';
import 'package:bhrammanbeta/data/essence_data.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileInfo();
  }

  String userName, userId, userProfilePic;

  getProfileInfo() async {
   await AuthService.getUserNameSharePref().then((value) {
       setState(() {
         userName = value;
       });
    });

   await AuthService.getUserIdSharedPref().then((value) {
     setState(() {
       userId = value;
     });
   });

   await AuthService.getProfilePhotoSharedPref().then((value) {
     setState(() {
       userProfilePic = value;
     });
   });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Stack(
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:  AssetImage(
                                  'assets/images/profile_back_img.jpg') ,
                            )
                        ),
                      ),
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.46,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(

                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.bottomLeft,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: userProfilePic == null ?
                                  AssetImage('assets/images/manone.png') : NetworkImage(userProfilePic),
                                ),
                              ),
                              SizedBox(width: 100,),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Container(

                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                         builder :  (context) => EditProfile(profilePic : userProfilePic, name : userName != null ? userName  : "Annonymous" , userId : userId)
                                      ));
                                    },
                                    splashColor: Colors.lightBlue,
                                    color: Colors.lightBlue,
                                    padding: EdgeInsets.only(
                                        left: 50, right: 52),
                                    child: Text("Edit Profile",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                          fontSize: 16),),
                                  ),
                                ),
                              )
                            ]
                        ),
                      ),
                    ]
                ),

                

                Container(
                  padding: EdgeInsets.only(left: 20,top: 5),
                  alignment: Alignment.topLeft,
                  child: Text(userName != null ? userName  : "Annonymous"
                    ,style: TextStyle(fontSize: 18,fontFamily:'sf_pro_semi_bold'),),
                ),

                SizedBox(height: 10,),

                cardContainer(text: "Start Live Stream", widget: LiveStreamForm() , icon: 'assets/icons/live_stream.png'),
                SizedBox(height: 10,),
                cardContainer(text: "Upload Videos",widget: VideoUploadForm(), icon: 'assets/icons/upload_video.png'),
                SizedBox(height: 10,),
                cardContainer(text: "Add a new story",widget: AddStoriesForm(), icon: 'assets/icons/story.png'),
                SizedBox(height: 10,),
                cardContainer(text: "Give Feedback", widget: FeedBack() , icon: 'assets/icons/feedback.png'),

                SizedBox(height: 20,),

                Container(
                  width: MediaQuery.of(context).size.width,

                  child: OutlineButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => BeforeLoginPage(),
                      ));
                    },
                    child: Text("SIGN OUT",style: TextStyle(fontFamily: 'sf_pro_bold',fontSize: 16),),
                    highlightColor: Colors.lightBlueAccent,
                  ),
                ),

              ],
            )
        )
    );
  }

  Widget cardContainer({String text,dynamic widget,dynamic icon}) {
    return   Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => widget,
            ));
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: white,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.lightBlue
                  ),
                  child: Icon(
                      Icons.add,
                    color: white,
                  ),
                ),
                SizedBox(width: 30,),
                Container(
                  child: Text(text,style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'normal_font'),),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

}

