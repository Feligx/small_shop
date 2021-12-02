import 'package:flutter/material.dart';
import 'package:projects/screens/register.dart';
import 'package:projects/screens/screen2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
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
      primarySwatch: Colors.green,
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

  String pass = '', usrnm='';
  final usr_field = TextEditingController();
  final pass_field = TextEditingController();

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
          children : [
            Container(
              margin: EdgeInsets.only(left: 0.0,top: 20.0,right: 0.0,bottom: 20.0),
                child:Text(
                    'Small Shop',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                )
            ),
            // Container(
            //     padding: EdgeInsets.all(20.0),
            //     child:Image.network('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png')
            // ),
            // ActionChip(
            //   avatar: Icon(Icons.favorite),
            //   label: Text('Action 1'),
            //   onPressed: () {},
            // ),
            Center(
              child: Text('Registro')
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: usr_field,
                // onSubmitted: (String txt){
                //   usrnm = txt;
                //   print(usrnm);
                // },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                ),
              )
            ),
            Container(
                padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 20.0),
              child:TextField(
                controller: pass_field,
                // onSubmitted: (String txt){
                //   pass = txt;
                //   print(pass);
                // },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              )
            ),
            //Container para el button de login
            Container(
              padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 0.0),
              child: ElevatedButton(
                child : Row(
                    children:[Icon(Icons.send), Text("Entrar", textAlign: TextAlign.center)]
                ),
                onPressed: (){
                  var user = "Felipe", password = "1234";
                  usrnm = usr_field.text;
                  pass = pass_field.text;

                  if (usrnm == "" || pass == ""){
                    print("Por favor ingresa los datos");
                  } else if(usrnm == user && pass == password){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>screen2())
                    );
                  } else{
                    print("Datos erróneos, vuelve a intentarlo");
                  }

                }
              )
            ),
            //Container para el button de registro
            Container(
                margin: EdgeInsets.only(left: 0.0,top: 20.0,right: 0.0,bottom: 0.0),
                padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 0.0),
                child: ElevatedButton(
                    child : Row(
                        children:[Icon(Icons.add), Text("¿No tienes una cuenta? Regístrate", textAlign: TextAlign.center)]
                    ),
                    onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context)=>register())
                        );
                    }
                )
            ),
          ]
      )
    );
  }
}
