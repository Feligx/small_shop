import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Small Shop',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
          children : [
            Container(
                child:Text(
                    'probando',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                )
            ),
            Container(
                padding: EdgeInsets.all(20.0),
                child:Image.network('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png')
            ),
          ]
      )
    );
  }
}
