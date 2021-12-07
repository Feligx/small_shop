import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/filtered_by_categories.dart';
import 'package:projects/screens/result_by_negocio.dart';
import 'package:projects/screens/screen2.dart';
import 'package:projects/screens/update_cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class filter_by_negocio extends StatelessWidget {

  final category_field = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario Consulta"),
      ),
      drawer: menuLateral(),
      body: Center( child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0, bottom: 20.0),
              child: TextField(
                controller: category_field,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Producto a buscar',
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
          ),
          Expanded(
              child: categoriesCards())
        ],
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


class categoriesCards extends StatefulWidget {

  @override
  _categoriesCardsState createState() => _categoriesCardsState();
}

class _categoriesCardsState extends State<categoriesCards> {

  List categoriesList=[];

  void initState(){
    super.initState();
    getCategories();
  }

  void getCategories() async{
    CollectionReference categoriesReference = FirebaseFirestore.instance.collection("categorias");
    QuerySnapshot categories = await categoriesReference.get();

    if(categories.docs.length != 0){
      for(var category in categories.docs){
        setState(() {
          categoriesList.add(category.data());
          print(category.data());
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻ ... a menos q no hayan datos ¯|_(ツ)_/¯");
    }

  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: categoriesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, i)=>
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>filtered_by_categories(category: categoriesList[i]['nombre'])));
          },
          child: Container(
          child: GridTile(
            child:Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Image.network(categoriesList[i]['foto']),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(categoriesList[i]['nombre'][0].toUpperCase()+categoriesList[i]['nombre'].substring(1), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),)
                      ,)
                  ]
                )
            )
          )
        )
        )
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
