import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/screen2.dart';
import 'package:fluttertoast/fluttertoast.dart';

class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Regístrate")
      ),
      body: register_form()
    );
  }
}


class register_form extends StatelessWidget {

  var usrnm = '', pass= '', tel='', dir='', name='', id='';
  final usr_field = TextEditingController();
  final pass_field = TextEditingController();
  final name_field = TextEditingController();
  final dir_field = TextEditingController();
  final tel_field = TextEditingController();
  final id_field = TextEditingController();

  CollectionReference clientesReference = FirebaseFirestore.instance.collection("clientes");

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            controller: usr_field,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-mail',
            ),
          )
      ),
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
              controller: id_field,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cédula',
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
        Container(
            padding: EdgeInsets.only(left: 50.0,top: 0.0,right: 50.0,bottom: 0.0),
            child: ElevatedButton(
                child : Row(
                    children:[Icon(Icons.add_business), Text("Crear cuenta", textAlign: TextAlign.center)]
                ),
                onPressed: () async{
                  usrnm = usr_field.text;
                  pass = pass_field.text;
                  name = name_field.text;
                  tel = tel_field.text;
                  dir = dir_field.text;
                  id = id_field.text;

                  if(usrnm.isNotEmpty && pass.isNotEmpty && name.isNotEmpty && tel.isNotEmpty && dir.isNotEmpty){
                    QuerySnapshot exists = await clientesReference.where(FieldPath.documentId, isEqualTo: id).get();
                    if(exists.docs.isNotEmpty){
                      print("El cliente ya existe");
                      Fluttertoast.showToast(msg: "Ya existe una cuenta con estos datos...");
                    }else {
                      clientesReference.doc(id).set({
                        "nombre": name,
                        "direccion": dir,
                        "telefono": tel,
                        "email": usrnm,
                        "password": pass,
                      });
                      QuerySnapshot exists = await clientesReference.where(FieldPath.documentId, isEqualTo: id).get();
                      if(exists.docs.isNotEmpty){
                        Fluttertoast.showToast(msg: "Registro completado.");
                      }
                    }
                  }else{
                    Fluttertoast.showToast(msg: "Hay datos vacíos, asegurate de llenar todos los campos");
                  }

                  usr_field.text='';
                  pass_field.text='';
                  name_field.text='';
                  tel_field.text='';
                  dir_field.text='';
                  id_field.text='';

                }
            )
        ),
      ],
    );
  }
}
