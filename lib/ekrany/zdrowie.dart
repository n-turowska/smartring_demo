import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Zdrowie extends StatelessWidget {
  const Zdrowie({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(child: Text('Zdrowie'),
        ),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: <Widget>[
            MainShape(kolor: Colors.blueGrey ,nazwa: "Ilość snu: 8h"),
            MainShape(kolor: Colors.blueGrey ,nazwa: "Jak bardzo się dziś stresujesz (1-10): 8"),
            MainShape(kolor:Colors.blueGrey ,nazwa: "Dobowy HRV: 40ms"),
            ],
      ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Navigator.popAndPushNamed(context, '/glowny');
        },
        child: const Icon(Icons.home),),
      );
      }
      }

  class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.lightBlueAccent,
      alignment: Alignment.center,
      child: const Text('Wykres',),
    );
  }

  }
  
