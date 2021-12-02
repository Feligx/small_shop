import 'package:flutter/material.dart';
import 'package:projects/main.dart';

class screen2 extends StatelessWidget {
  //const screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2nd Screen")
        ),
      body: app_body(),
      bottomNavigationBar: bottom_nav(),
    );
  }
}

class app_body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      children:[
        Center(
          child: Text("Welcome to 2nd screen")
        ),
        Center(
            child: Text("Hi!!!!!1!")
        ),
      ]
    );
  }
}

class bottom_nav extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index){
        if(index == 0){
          Navigator.pop(context);
        }else if(index == 1){
          var time = DateTime.now();
          print(time);
        }else{
          print("should go to 3rd screen");
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: "Back"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: "Next"
        ),
      ],
    );
  }
}

