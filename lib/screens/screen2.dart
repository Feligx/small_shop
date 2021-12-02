import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/main.dart';

import 'filterbynegocio.dart';

class screen2 extends StatelessWidget {
  //const screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Negocios")
        ),
      body: app_body(),
      // bottomNavigationBar: bottom_nav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>filter_by_negocio()));
        },
        icon: Icon(Icons.arrow_forward),
        label: Text('Siguiente'),),
    );
  }
}

class app_body extends StatefulWidget {
  @override
  _app_bodyState createState() => _app_bodyState();
}

class _app_bodyState extends State<app_body> {

  List negocios_list = [];

  void initState(){
    super.initState();
    getNegocios();
  }
  void getNegocios() async{
    CollectionReference datos = FirebaseFirestore.instance.collection("negocios"); //conexion a la colección "negocios"
    QuerySnapshot negocios = await datos.get();
    if(negocios.docs.length > 0){
      print("Trae datos");
      for (var p in negocios.docs){
        setState(() {
          print(p.data());
          negocios_list.add(p.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: negocios_list.length,
        itemBuilder: (BuildContext context, i){
          return Container(
            color: Colors.amberAccent,
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(5.0),
            child: Text(
              "Persona"+i.toString()+" "+negocios_list[i]['nombre'].toString()+negocios_list[i]['categoria'].toString(),
            ),
          );
      },
      ),
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

