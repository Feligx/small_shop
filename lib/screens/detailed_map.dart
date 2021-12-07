import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class detailed_map extends StatefulWidget {
  final String nombre;
  final GeoPoint positionNegocio;
  const detailed_map({required this.nombre, required this.positionNegocio});

  @override
  _detailed_mapState createState() => _detailed_mapState();
}

class _detailed_mapState extends State<detailed_map> {

  List negociosList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPos();
  }

  // void getPos() async{
  //   print(widget.nombre);
  //   CollectionReference negociosReference = FirebaseFirestore.instance.collection("negocios");
  //   QuerySnapshot negocios = await negociosReference.where("nombre", isEqualTo: widget.nombre).get();
  //
  //   if(negocios.docs.isNotEmpty){
  //     for(int i=0; i<negocios.docs.length; i++){
  //       negociosList.add(negocios.docs[i].data());
  //     }
  //     position=negociosList[0]['geolocalizacion'];
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    final posicion= CameraPosition(target: LatLng(widget.positionNegocio.latitude,widget.positionNegocio.longitude), zoom: 15);

    final Set<Marker> marker = Set();
    
    marker.add(Marker(markerId: MarkerId("123"), position: LatLng(widget.positionNegocio.latitude,widget.positionNegocio.longitude),icon: BitmapDescriptor.defaultMarker, infoWindow: InfoWindow(title: widget.nombre)));
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del negocio")
      ),
      body: GoogleMap(
        initialCameraPosition: posicion,
        scrollGesturesEnabled: true, //movimiento del mapa
        zoomControlsEnabled: false,
        markers: marker,
      ),
    );
  }
}
