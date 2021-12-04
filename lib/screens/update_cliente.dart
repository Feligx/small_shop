import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projects/main.dart';

class updateCliente extends StatefulWidget {
  final String email;
  const updateCliente({required this.email});

  @override
  _updateClienteState createState() => _updateClienteState();
}

class _updateClienteState extends State<updateCliente> {

  List dataCliente=[];
  String pass='', dir='', tel='', name='';

  final pass_field = TextEditingController();
  final name_field = TextEditingController();
  final dir_field = TextEditingController();
  final tel_field = TextEditingController();
  final id_field = TextEditingController();

  void initState(){
    super.initState();
    getDatos();
    pass_field.text=pass;
    name_field.text=name;
    dir_field.text=dir;
    tel_field.text=tel;
  }

  void getDatos() async{
    CollectionReference productsReference = FirebaseFirestore.instance.collection("clientes");
    QuerySnapshot user = await productsReference.where("email", isEqualTo:widget.email).get();

    if (user.docs.isNotEmpty){
      dataCliente.add(user.docs[0].data());
      name=dataCliente[0]['nombre'];
      pass=dataCliente[0]['password'];
      tel=dataCliente[0]['telefono'];
      dir=dataCliente[0]['dir'];
    }
  }

  @override
  Widget build(BuildContext context) {

    // pass_field.text=pass;
    // name_field.text=name;
    // dir_field.text=dir;
    // tel_field.text=dir;
    // id_field.text=dir;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
            Text("Editar Cuenta"),
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back))
          ]
        )
      ),
      drawer: Drawer(),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 20.0),
              child:TextField(
                controller: pass_field,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 20.0),
              child:TextField(
                controller: name_field,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 20.0),
              child:TextField(
                controller: dir_field,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dirección',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 20.0),
              child:TextField(
                controller: tel_field,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Telefono',
                ),
              )
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async{
                    CollectionReference clienteReference = FirebaseFirestore.instance.collection("clientes");
                    QuerySnapshot cliente = await clienteReference.where("email", isEqualTo:widget.email).get();

                    var id = cliente.docs[0].id;

                    if(pass_field.text.isEmpty || name_field.text.isEmpty || dir_field.text.isEmpty || tel_field.text.isEmpty){
                      Fluttertoast.showToast(msg: "Hay campos vacíos, asegurte de llenarlos todos.");
                    }else{
                      clienteReference.doc(id).update(
                          {
                            "password": pass_field.text,
                            "nombre": name_field.text,
                            "direccion": dir_field.text,
                            "telefono": tel_field.text,
                          }
                      );
                      Fluttertoast.showToast(msg: "Datos actualizados correctamente");
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Actualizar"),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async{
                    CollectionReference clienteReference = FirebaseFirestore.instance.collection("clientes");
                    QuerySnapshot cliente = await clienteReference.where("email", isEqualTo:widget.email).get();

                    var id = cliente.docs[0].id;
                    clienteReference.doc(id).delete();
                    Fluttertoast.showToast(msg: "Cuenta eliminada correctamente");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));

                  },
                  child: Text("Borrar cuenta"),
                ),
              )
            ],
          )
        ],
      )
    );
  }
}
