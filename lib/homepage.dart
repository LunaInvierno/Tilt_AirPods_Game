import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Player variables to move in x-direction
  double playerx O;

  void moveLeft() {

  }

void moveRight() {

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment(playerx, 1),
                        child: Container(
                          color: Colors.deepPurple[900],
                          height: 50,
                          width: 50,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: Container(
              color: Colors.grey,
             )
        ),
      ],
    );
  }
}
