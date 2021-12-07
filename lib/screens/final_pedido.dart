import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/screen2.dart';
import 'package:projects/screens/update_cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filterbynegocio.dart';
import 'dart:collection';

class final_pedido extends StatefulWidget {
  final Map<dynamic, dynamic> pedido;
  const final_pedido({required this.pedido});

  @override
  _final_pedidoState createState() => _final_pedidoState();
}

class _final_pedidoState extends State<final_pedido> {
  @override

  List prods=[];
  num total=0;
  var subtotal=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductos();
  }

  void getProductos() async{
    CollectionReference productosReference = FirebaseFirestore.instance.collection("productos");

    for(var i=0; i<widget.pedido.length; i++) {
      QuerySnapshot productos = await productosReference.where(FieldPath.documentId, isEqualTo: widget.pedido.keys.toList()[i]).get();
      prods.add(productos.docs[0].data());
    }
    for(int i=0; i<prods.length; i++){
      print("Subtotal: ");
      var val = widget.pedido[widget.pedido.keys.toList()[i]]*int.parse(prods[i]['precio']);
      print(widget.pedido[widget.pedido.keys.toList()[i]]*int.parse(prods[i]['precio']));
      subtotal.add(val);
      total+=val;
    }
    print(subtotal);
    setState(() {

    });
  }

  Widget build(BuildContext context) {
    print(widget.pedido[widget.pedido.keys.toList()[0]].toString());
    return Scaffold(
      appBar: AppBar( title: Text("Comprobante del pedido")),
      drawer: menuLateral(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prods.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Card(
                    child: Row(
                      children: [
                        Image.network(prods[i]["foto"], scale: 5),
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(children: [
                          Text(prods[i]['nombre']),
                          Text("x"+widget.pedido[widget.pedido.keys.toList()[i]].toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                          Text("Precio: "+subtotal[i].toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
                          ]
                          ,)
                        ,)
                        // Container(
                        //   margin: EdgeInsets.only(left: 20.0),
                        //     child: Text(prods[i]['Nombre'] + "x"+widget.pedido[widget.pedido.keys.toList()[i].toString()])
                        // )
                      ],
                    ),
                  ),
                );
              },)
          ),
          Container(margin: EdgeInsets.only(bottom: 50.0),child: Center(child: Text("Total: \$"+total.toString(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>screen2()));
        },
        child: const Icon(Icons.home),
        backgroundColor: Colors.green,
      ),
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
