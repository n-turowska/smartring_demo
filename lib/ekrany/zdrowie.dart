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
          children: <Widget>[MyWidget(),],
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
      child: const Text(
        'HELLO WORLD',
        style: TextStyle(color: Colors.black, fontSize: 32),
      ),
    );
  }

  }
  
