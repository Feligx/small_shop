import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class detailed_negocio extends StatelessWidget {
  final LinkedHashMap<String, dynamic> negocio;
  final String index;
  const detailed_negocio({required this.negocio, required this.index});

  @override
  Widget build(BuildContext context) {
    print("index: "+index);
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children: [
              Text(negocio['nombre']),
            ]
        )
      ),
      drawer: Drawer(),
      body: ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(negocio['logo']), radius: 50.0,),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                  child:Column(
                      children: [
                        Text(negocio['nombre'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        Container(
                            child: Row(
                              children: [
                                TextButton.icon(
                                onPressed: (){
                                  launch(negocio['web']);
                                },
                                icon: Icon(Icons.language),
                                label: Text("Website", style: TextStyle(fontSize: 15))
                                ,),
                              ]
                            )
                        ),
                        Text("Contacto: "+negocio['contacto'].toString(), style: TextStyle(color: Colors.green),)
                      ]
                  )
              )
            ],
          )
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Text("Productos:", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.green),)
        ),
        Container(
            child: productsCards(negocio: negocio, negocioId: index,)
        )
      ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class productsCards extends StatefulWidget {
  final LinkedHashMap<String, dynamic> negocio;
  final String negocioId;

  const productsCards({required this.negocio, required this.negocioId});

  @override
  _productsCardsState createState() => _productsCardsState();
}

class _productsCardsState extends State<productsCards> {

  var productos=[];

  void initState(){
    super.initState();
    getProducts();
  }

  void getProducts() async{
    CollectionReference productsReference = FirebaseFirestore.instance.collection("productos");
    QuerySnapshot products = await productsReference.where("negocio", isEqualTo:widget.negocioId).get();

    if(products.docs.length != 0){
      for(var prod in products.docs){
        setState(() {
          productos.add(prod.data());
          print(prod.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: productos.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          onTap: (){

          },
          title:Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Image.network(productos[i]['foto'], scale: 5),
                Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                          child: Text(productos[i]['nombre'][0].toUpperCase()+(productos[i]['nombre'].substring(1))+"\n"+"Precio: "+productos[i]['precio'].toString(), style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,)
                      )
                    ]
                )
              ],
            ),
          )
        );
      },
    );
  }
}