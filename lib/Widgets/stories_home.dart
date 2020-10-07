import 'package:flutter/material.dart';

class Stories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 55.0,
                width: 55.0,
                child: Material(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Colors.black,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                ' New ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.0,
                  shadows: [
                    Shadow(
                      blurRadius: 0.3,
                      color: Colors.black12,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(60.0),
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                              AssetImage('assets/images/mantwo.png'),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    ' Prabhat ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.0,
                      shadows: [
                        Shadow(
                          blurRadius: 0.3,
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(60.0),
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/manthree.png'),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    ' Shakti-Maan ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.0,
                      shadows: [
                        Shadow(
                          blurRadius: 0.3,
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(60.0),
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/womanone.png'),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    ' Rama ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.0,
                      shadows: [
                        Shadow(
                          blurRadius: 0.3,
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(60.0),
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/womantwo.png'),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    ' Geeta Bai ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.0,
                      shadows: [
                        Shadow(
                          blurRadius: 0.3,
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
