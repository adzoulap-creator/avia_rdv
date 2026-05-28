import 'package:flutter/material.dart';
import 'screens/accueil.dart';

void main(){
  runApp(Avia());
}

class Avia extends StatelessWidget{
  @override
  Widget build(BuildContext context){


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeroSection(),
    );
  }
}