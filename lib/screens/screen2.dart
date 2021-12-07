import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/main.dart';
import 'package:projects/screens/result_by_negocio.dart';
import 'package:projects/screens/update_cliente.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

import 'datailed_negocio.dart';
import 'filterbynegocio.dart';

class screen2 extends StatelessWidget {
  //const screen2({Key? key}) : super(key: key);

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Negocios")
        ),
      drawer: menuLateral(),
      body: app_body(),
      // bottomNavigationBar: bottom_nav(),
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: (){
    //       Navigator.push(context, MaterialPageRoute(builder: (context)=>filter_by_negocio()));
    //     },
    //     icon: Icon(Icons.filter_alt_rounded),
    //     label: Text('Filtrar'),),
      floatingActionButton: ExpandableFab(
        distance: 80.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>filter_by_negocio()));
            },
            icon: const Icon(Icons.filter_alt_rounded),
          ),
        ],
    ),
    );
  }
}

class app_body extends StatefulWidget {
  @override
  _app_bodyState createState() => _app_bodyState();
}

class _app_bodyState extends State<app_body> {

  List negocios_list = [];
  List DocsIds=[];
  void initState(){
    super.initState();
    getNegocios();
  }
  void getNegocios() async{
    CollectionReference datos = FirebaseFirestore.instance.collection("negocios"); //conexion a la colección "negocios"
    QuerySnapshot negocios = await datos.get();
    if(negocios.docs.length > 0){
      print("Trae datos");
      for (var p in negocios.docs){
        setState(() {
          print(p.data());
          negocios_list.add(p.data());
          print(p.id);
          DocsIds.add(p.id);
        });
      }
    }else{
      print("No deberías de llegar aquí (╯°□°）╯︵ ┻━┻");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(

        itemCount: negocios_list.length,
        itemBuilder: (BuildContext context, i){
          return Container(

            // color: Colors.amberAccent,
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(5.0),
            // child: Text(
            //   "Persona"+i.toString()+" "+negocios_list[i]['nombre'].toString()+negocios_list[i]['categoria'].toString(),
            // ),
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>detailed_negocio(negocio: negocios_list[i], index: DocsIds[i],)));
              },
              title: cardProducto(img: negocios_list[i]['logo'], name: negocios_list[i]['nombre'], contacto: negocios_list[i]['contacto'].toString(), url: negocios_list[i]['web'], dir: negocios_list[i]['direccion'],))
          );
      },
      ),
    );
  }
}


class bottom_nav extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index){
        if(index == 0){
          Navigator.pop(context);
        }else if(index == 1){
          var time = DateTime.now();
          print(time);
        }else{
          print("should go to 3rd screen");
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: "Back"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: "Next"
        ),
      ],
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 90.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.more_horiz),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 360.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
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