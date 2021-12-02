import 'package:flutter/material.dart';
import 'package:projects/screens/result_by_negocio.dart';

class filter_by_negocio extends StatelessWidget {

  final category_field = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario Consulta"),
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.all(50.0),
              child: TextField(
                controller: category_field,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Categoría a buscar',
                  suffixIcon: Icon(Icons.filter_alt_rounded)
                ),
              )
          ),
          Container(
            child: ElevatedButton(
              onPressed: (){
                var category_filter= category_field.text;
                print(category_filter);
                if(category_filter != ''){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>result_by_negocio(category_filter)));
                }
              },
              child: Text("Consultar"),
            ),
          )
        ],
      ),
    );
  }
}
