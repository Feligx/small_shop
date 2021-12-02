import 'package:flutter/material.dart';
import 'package:projects/screens/screen2.dart';

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

  var usrnm = '', pass= '';
  final usr_field = TextEditingController();
  final pass_field = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            controller: usr_field,
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
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Contraseña',
            ),
          )
      ),
        Container(
            padding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0,bottom: 0.0),
            child: ElevatedButton(
                child : Row(
                    children:[Icon(Icons.add_business), Text("Send", textAlign: TextAlign.center)]
                ),
                onPressed: (){
                  usrnm = usr_field.text;
                  pass = pass_field.text;

                  if (usrnm == "" || pass == ""){
                    print("Por favor ingresa los datos");
                  } else if(usrnm != "" || pass != ""){

                    //codigo para hacer el registro de users en firebase

                    Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>screen2())
                    );
                  } else{
                    print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻");
                  }

                }
            )
        ),
      ],
    );
  }
}
