import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class result_by_negocio extends StatefulWidget {

  final String filter;
  const result_by_negocio(this.filter, {Key? key}) : super(key: key);

  @override
  _result_by_negocioState createState() => _result_by_negocioState();
}

class _result_by_negocioState extends State<result_by_negocio> {

  List negocios_list=[];
  List productos_list=[];

  void initState(){
    super.initState();
    getFilterProduct();
  }

  void getFilterCategory() async{
    //TODO implement second foo to redo the filter by category
    // if (negocioFiltered.docs.length != 0){
    //   for(var neg in negocioFiltered.docs){
    //     setState(() {
    //       negocios_list.add(neg.data());
    //       print(neg.data());
    //     });
    //   }
    // }else
    }

  void getFilterProduct() async{
    CollectionReference negocio = FirebaseFirestore.instance.collection("negocios");
    QuerySnapshot negocioFiltered = await negocio.where("categoria", isEqualTo:widget.filter).orderBy("nombre", descending: false).get();

    CollectionReference producto = FirebaseFirestore.instance.collection("productos");
    QuerySnapshot productoFiltered = await producto.where("nombre", isEqualTo:widget.filter).get();

    if(productoFiltered.docs.length != 0){
      for(var prod in productoFiltered.docs){
        setState(() {
          productos_list.add(prod.data());
          print(prod.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }

    List id=[];
    for(var i=0; i<productos_list.length; i++){
      id.add(productos_list[i]['negocio']);
      print(id);
    }

    QuerySnapshot negocioById = await negocio.where(FieldPath.documentId, whereIn: id).get();
    if (negocioById.docs.length != 0){
      for(var p in negocioById.docs){
        setState(() {
          negocios_list.add(p.data());
          print(p.data());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados: "+widget.filter),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: negocios_list.length,
            // itemCount: productos_list.length,
            itemBuilder: (BuildContext context, i){
              return Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: cardProducto(img: negocios_list[i]['foto'], txt: negocios_list[i]['nombre']+"\n Contacto: "+negocios_list[i]['contacto'].toString())
              );
            },
          ),
        )
    );
  }
}

class cardProducto extends StatelessWidget {
  final String img;
  final String txt;
  const cardProducto({required this.img, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: EdgeInsets.all(20.0),
      elevation: 15,
      color: Colors.amber,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Column(
          children: [
            Image.network(img),
            Container(
                color: Colors.amber,
                margin: EdgeInsets.all(20.0),
                child: Text(txt, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            )
          ],
        ),
      ),
    );
  }
}
