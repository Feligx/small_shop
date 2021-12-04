import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/screens/datailed_negocio.dart';

class result_by_negocio extends StatefulWidget {

  final String filter;
  const result_by_negocio(this.filter, {Key? key}) : super(key: key);

  @override
  _result_by_negocioState createState() => _result_by_negocioState();
}

class _result_by_negocioState extends State<result_by_negocio> {

  List negocios_list=[];
  List productos_list=[];
  List DocsIds=[];

  void initState(){
    super.initState();
    getFilterProduct();
  }

  void getFilterCategory() async{
    CollectionReference negocio = FirebaseFirestore.instance.collection("negocios");
    QuerySnapshot negocioFiltered = await negocio.where("categoria", isEqualTo:widget.filter).orderBy("nombre", descending: false).get();
    //TODO implement second foo to redo the filter by category, despite it could be useless since the categ separation is done in previous screen
    if (negocioFiltered.docs.length != 0){
      for(var neg in negocioFiltered.docs){
        setState(() {
          negocios_list.add(neg.data());
          print(neg.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }
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
          print("Doc id?");
          print(p.id);
          DocsIds.add(p.id);
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
      drawer: Drawer(),
      body: Center(
        child: ListView.builder(
            itemCount: negocios_list.length,
            itemBuilder: (BuildContext context, i){
              return ListTile(
                onTap: (){
                  print(negocios_list[i].runtimeType);
                  print(negocios_list[i]);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>detailed_negocio(negocio: negocios_list[i], index: DocsIds[i],)));
                },
                title: cardProducto(img: negocios_list[i]['foto'], name: negocios_list[i]['nombre'], contacto: negocios_list[i]['contacto'].toString(), dir: negocios_list[i]['direccion'], url: negocios_list[i]['web'],)
              );
            },
          ),
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

class cardProducto extends StatelessWidget {
  final String img;
  final String name;
  final String contacto;
  final String url;
  final String dir;
const cardProducto({required this.img, required this.name, required this.contacto, required this.url,required this.dir});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(img),
          MyStatefulWidget(name_negocio: name, contacto: contacto, url: url, dir: dir,),
          //
        ],
      ),
    );
  }
}


class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems, String name, String contacto, String url, String dir) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: '$name',
      expandedValue: 'Contacto: $contacto\nDirección: $dir\nWeb: $url',
    );
  });
}

class MyStatefulWidget extends StatefulWidget {
  final String name_negocio, contacto, url, dir;
  const MyStatefulWidget({required this.name_negocio, required this.contacto, required this.url, required this.dir});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String name = '';
  String contacto = '';
  String url = '';
  String dir = '';
  late final List<Item> _data;

  @override
  void initState(){
    name=widget.name_negocio;
    contacto=widget.contacto;
    url=widget.url;
    dir=widget.dir;
    _data = generateItems(1,name, contacto, url, dir);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue, style: TextStyle(fontSize: 12, color: Colors.grey),),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}