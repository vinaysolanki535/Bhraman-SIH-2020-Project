import 'package:bhrammanbeta/Screens/web_view.dart';
import 'package:bhrammanbeta/Widgets/exploreCards.dart';
import 'package:bhrammanbeta/resource/color.dart';
import "package:flutter/material.dart";


class SwitchSection extends StatefulWidget {
  final String url;
  SwitchSection({this.url});
  @override
  _SwitchSectionState createState() => _SwitchSectionState();
}

class _SwitchSectionState extends State<SwitchSection> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Switch",style: TextStyle(color: Colors.lightBlue,fontSize: 24),),

        backgroundColor: Colors.white,

        iconTheme: IconThemeData(
          color: black,
        ),

      ),
      body: SingleChildScrollView(
        child:  Container(
          child : Column(
            children: [



              ExploreCard(
                  image: 'assets/images/swiggy.png',
                  title: "Swiggy",
                widget: Container(),
                  fit: BoxFit.cover,
                  titleColor: Colors.black,
                  onTapWidget: WebViewScreen('https://www.swiggy.com/'),
                ),


              SizedBox(height: 10,),

              ExploreCard(
                image: 'assets/images/irctc.png',
                title: "IRCTC",
                widget: Container(),
                fit: BoxFit.fitWidth,
                titleColor: Colors.black,
                onTapWidget: WebViewScreen("https://www.irctc.co.in/nget/train-search"),
              ),

              SizedBox(height: 10,),

              ExploreCard(
                image: 'assets/images/oyo.png',
                title: "OYO",
                widget: Container(),
                fit: BoxFit.fitHeight,
                titleColor: Colors.black,
                onTapWidget: WebViewScreen("https://www.oyorooms.com/?utm_source=google&utm_medium=cpc&utm_campaign=India_SEM_Brand_generic&gclid=CjwKCAjw9vn4BRBaEiwAh0muDOJZ79DLoILELhtwl4AXC7KUIP8lR0D8_pY8jwdPjFSUTgDlHpMpiRoCKakQAvD_BwE"),
              ),

              SizedBox(height: 10,),

              ExploreCard(
                image: 'assets/images/ola.jpeg',
                title: "OLA",
                widget: Container(),
                fit: BoxFit.fitHeight,
                titleColor: Colors.black,
                onTapWidget: WebViewScreen("https://book.olacabs.com/"),
              ),


            ],
          )
        ),
      ),
    );
  }
}
