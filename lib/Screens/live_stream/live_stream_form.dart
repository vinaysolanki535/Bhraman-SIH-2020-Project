import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bhrammanbeta/Screens/live_stream/pages/call.dart';
import 'package:bhrammanbeta/Widgets/form_field.dart';
import 'package:bhrammanbeta/database/auth.dart';
import 'package:bhrammanbeta/database/firestore.dart';
import 'package:bhrammanbeta/resource/color.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamForm extends StatefulWidget {
  @override
  _LiveStreamFormState createState() => _LiveStreamFormState();
}

class _LiveStreamFormState extends State<LiveStreamForm> {

  String dropdownValue = 'Select';




  final _formKey = GlobalKey<FormState>();
  TextEditingController broadCastingIdController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  bool clicked = false;

  DatabaseService databaseService = DatabaseService();

  @override
  initState(){
    super.initState();
    getUserName();
    getUserId();
  }

  String userName = '';



  getUserName() async{
    await AuthService.getUserNameSharePref().then((value) {
        setState(() {
          userName  = value;
        });
    });
  }

  String userId;
  getUserId() async {
    await AuthService.getUserIdSharedPref().then((value){
      setState(() {
        userId = value.toString();
      });
    });
  }


  Widget submitBtn() {
    if(clicked ==  false) {
      return MaterialButton(
        minWidth: double.infinity,
        color: Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(58.0),
        ),
        onPressed: () async{

          if(!_formKey.currentState.validate()) {
            print(broadCastingIdController.text);
            print(placeController.text);
            print(cityController.text);
            print(dropdownValue);
          }
          else {
            setState(() {
              clicked = true;
            });

            await _handleCameraAndMic();

            await databaseService.saveLiveStreamDataToFirebase(
              broadcastingId: broadCastingIdController.text,
              placeName: placeController.text,
              state: dropdownValue,
              city: cityController.text,
              userName: userName,
              userId: userId,
            );

            Navigator.pop(context);
            await Navigator.push(context, MaterialPageRoute(
               builder: (context) => CallPage(channelName: broadCastingIdController.text,role: ClientRole.Broadcaster,),
            ));


          }
        },
        height: 50.0,
        child: Text("Go Live", style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: 'sf_pro_bold',
        ),),
      );
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(

        title: const Text('Live Streaming',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'sf_pro_bold')),
        backgroundColor: Colors.lightBlue,
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(

                children: <Widget>[


                  FormInputField(
                    inputLabel: "Broadcasting Id*",
                    hintText: "eg: yourname@surname",
                    textController: broadCastingIdController,
                    validator: (value) {
                    if(value.isEmpty) {
                      return "Broadcasting Id is empty";
                    }
                    if(!value.contains(userName) && !value.contains('@')) {
                      return "Id should be as yourname@surname";
                    }
                    return null;
                   },

                  ),

                  SizedBox(height: 20,),

                  FormInputField(
                    inputLabel: "Place*",
                    hintText: "eg: TajMahal, KanordPlace",
                    textController: placeController,
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Place should not be empty";
                      }

                      return null;
                    },

                  ),

                  SizedBox(height: 20,),

                  FormInputField(
                    inputLabel: "City*",
                    hintText: "eg: Delhi",
                    textController: cityController,
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Place should not be empty";
                      }
                      return null;
                    },

                  ),


                  SizedBox(
                    height: 20,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'State*',
                        style: TextStyle(
                            fontFamily: 'sf_pro_semi_bold',
                            fontSize: 20,
                            color: black,
                           ),
                      ),

                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Select',
                          'Madhya Pradesh',
                          'New Delhi',
                          'Rajasthan',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),

                  SizedBox(height: 30,),
                  submitBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    print(status['PermissionStatus']);
  }
}
