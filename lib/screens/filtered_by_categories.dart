import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/screen2.dart';
import 'package:projects/screens/update_cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datailed_negocio.dart';
import 'filterbynegocio.dart';

class filtered_by_categories extends StatefulWidget {
  final String category;
  const filtered_by_categories({required this.category});

  //TODO terminar de implementar este archivo
  @override
  _filtered_by_categoriesState createState() => _filtered_by_categoriesState();
}

class _filtered_by_categoriesState extends State<filtered_by_categories> {

  List negocios_list=[];
  List DocsIds=[];

  void initState(){
    super.initState();
    getFilterCategory();
  }

  void getFilterCategory() async{
    CollectionReference negocio = FirebaseFirestore.instance.collection("negocios");
    QuerySnapshot negocioFiltered = await negocio.where("categoria", isEqualTo:widget.category).orderBy("nombre", descending: false).get();
    //TODO implement second foo to redo the filter by category, despite it could be useless since the categ separation is done in previous screen
    if (negocioFiltered.docs.length != 0){
      for(var neg in negocioFiltered.docs){
        setState(() {
          negocios_list.add(neg.data());
          print(neg.data());
          DocsIds.add(neg.id);
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      drawer: menuLateral(),
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
