import 'package:firebase_messaging/firebase_messaging.dart';


class generartoken{

  FirebaseMessaging generar = FirebaseMessaging.instance;

  notificaciones(){
    generar.requestPermission();
    generar.getToken().then((token){
      print("------token------");
      print(token);
    });

  }


}