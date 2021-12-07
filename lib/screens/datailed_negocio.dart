import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/detailed_map.dart';
import 'package:projects/screens/final_pedido.dart';
import 'package:projects/screens/screen2.dart';
import 'package:projects/screens/update_cliente.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filterbynegocio.dart';

var quantities;
var productos;
var productosIds;

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
      drawer: menuLateral(),
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
                        Container(
                            child: Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      //negocio['geolocalizacion'];
                                      print(negocio['nombre']);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>detailed_map(nombre: negocio['nombre'], positionNegocio: negocio['geolocalizacion'],)));
                                    },
                                    icon: Icon(Icons.location_pin),
                                    label: Text("Ubicación", style: TextStyle(fontSize: 15))
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
        ),
        Container(
          margin: EdgeInsets.only(left: 100.0, right: 100.0, top: 20.0),
            child:ElevatedButton(
              onPressed: () {

                print(productos[0]);
                Map pedido = {};
                print(pedido.runtimeType);
                num total=0;
                for(var i=0; i<productos.length; i++){
                  pedido[productosIds[i]]=quantities[i];
                  total+=(int.parse(productos[i]['precio'])*quantities[i]);
                }

                print(pedido.runtimeType);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmación del pedido'),
                    content: Column(children:
                      [Expanded(
                        child: ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Column(children:[Text(productos[i]['nombre'] + " - Cant. " +quantities[i].toString())]),
                          );
                        },
                        ),
                      ),
                      Center(child: Text("Total de la compra:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)),
                      Center(child: Text("\$"+total.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),))
                      ]
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Editar pedido'),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String email = prefs.getString('email').toString();

                          CollectionReference pedidosReference = FirebaseFirestore.instance.collection("pedidos");
                          CollectionReference clientesReference = FirebaseFirestore.instance.collection("clientes");
                          QuerySnapshot cliente = await clientesReference.where("email", isEqualTo:email).get();

                          setState(){

                          }

                          pedidosReference.doc().set({
                            "productos":pedido,
                            "total":total,
                            "cliente": cliente.docs[0].id,
                            "fecha": DateTime.now(),
                            "negocio": index
                          });
                          print(pedido.runtimeType);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>final_pedido(pedido: pedido,)));
                        },
                        child: const Text('Confirmar pedido'),
                      ),
                    ],
                  ),
                );
              },
              child: Row(children: [Icon(Icons.shopping_cart_rounded), Text("Hacer Pedido")],),),
        ),
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

  void initState(){
    super.initState();
    getProducts();
  }

  void getProducts() async{

    quantities=[];
    productos=[];
    productosIds=[];

    CollectionReference productsReference = FirebaseFirestore.instance.collection("productos");
    QuerySnapshot products = await productsReference.where("negocio", isEqualTo:widget.negocioId).get();

    if(products.docs.length != 0){
      for(var prod in products.docs){
        setState(() {
          productos.add(prod.data());
          quantities.add(0);
          productosIds.add(prod.id);
          print(prod.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }

  }

  @override
  Widget build(BuildContext context) {
    int quant=0;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: productos.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title:Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Container(child: Image.network(productos[i]['foto'], scale: 5)),
                Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30.0,bottom: 5),
                          child: Text(productos[i]['nombre'][0].toUpperCase()+(productos[i]['nombre'].substring(1))+"\n"+"Precio: "+productos[i]['precio'].toString(), style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,)
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Row(
                        children: [
                          Ink(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.green
                            ),
                            child: IconButton(
                              constraints: BoxConstraints(maxHeight: 30.0,maxWidth: 30.0),
                              color: Colors.white,
                              iconSize: 10.0,
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantities[i]>0) {
                                    quantities[i] = quantities[i] - 1;
                                  }
                                });
                              },
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0,right: 10.0),
                            child: Text("Cant: "+ (quantities[i]).toString()),
                          ),
                          Ink(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                              color: Colors.green
                            ),
                            child: IconButton(
                            color: Colors.white,
                            iconSize: 10.0,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantities[i]=quantities[i]+1;
                              });
                            },
                          ),
                          )
                      ],)
                      )
                    ]
                ),
              ],
            ),
          )
        );
      },
    );
  }
}

class menuLateral extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color : Colors.green),
              child: Image.network("http://bluerocketlab.com/wp-content/uploads/2020/04/BR_logo_2019_bl@500.png")
          ),
          ListTile(
              leading: Icon(Icons.account_circle_rounded, size: 30),
              title: Text("Actualizar cuenta"),
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String email = prefs.getString('email').toString();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => updateCliente(email: email)));
              }
          ),
          ListTile(
              leading: Icon(Icons.search, size: 30),
              title: Text("Consultar Negocios"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => screen2()));
              }
          ),
          ListTile(
              leading: Icon(Icons.filter_alt_rounded, size: 30),
              title: Text("Filtrar negocios"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => filter_by_negocio()));
              }
          ),
          ListTile(
              leading: Icon(Icons.shopping_cart_rounded, size: 30),
              title: Text("Mi carrito"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => filter_by_negocio()));
              }
          ),

        ],
      ),
    );
  }
}