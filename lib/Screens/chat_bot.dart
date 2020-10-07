import 'package:bhrammanbeta/resource/color.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart'  as df;

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {

  void response(String query) async{
    df.AuthGoogle authGoogle = await df.AuthGoogle(fileJson: 'assets/chat_json.json').build();
    df.Dialogflow dialogflow = df.Dialogflow(authGoogle: authGoogle, sessionId: '123456');
    df.DetectIntentResponse response = await dialogflow.detectIntentFromText(query,df.Language.english);
    if(response.queryResult!=null) {
      setState(() {
        messsages.insert(0, {
          "data": 0,
          "message": response.queryResult.fulfillmentText.toString()
        });
      });
    }
    else{
      print("NO data");
    }

  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Travel Guide",
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount:messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 5.0,
              color: Colors.blueAccent,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'sf_pro_bold',
                            fontSize: 18.0
                        ),
                        controller: messageInsert,
                        decoration: InputDecoration.collapsed(
                            hintText: "Ask Me Something",
                            hintStyle: TextStyle(
                                fontFamily: 'sf_pro_bold',
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(

                        icon: Icon(

                          Icons.send,
                          size: 30.0,
                          color: blueGreen,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.green : Colors.blue,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),

                SizedBox(height: 5,),
                data == 0 ? Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,child: Text("Bot")) : Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,child: Text("You")),

              ],
            ),
          )),
    );


  }
}
