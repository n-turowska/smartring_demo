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
            MainShape(kolor: Color.fromARGB(255, 158, 154, 244),nazwa: "Ilość snu: 8h"),
            MainShape(kolor:Color.fromARGB(255, 158, 154, 244) ,nazwa: "Dobowy HRV: 40ms"),
            Stres(kolor: Color.fromARGB(255, 158, 154, 244) ,nazwa: "                Poziom stresu: ",), //tak na daną chwilę, potem użyje Stack zamiac Row
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
  
  class Stres extends StatefulWidget{
  final dynamic kolor;
  
  final dynamic nazwa;
  
    const Stres({super.key,
    this.kolor = Colors.lightBlueAccent,
    required this.nazwa});

    @override
    State<Stres> createState() => _PoziomStresuState();
  }

  class _PoziomStresuState extends State<Stres>{
    int _counter = 0;
    
     //late final dynamic kolor;
      //late final dynamic nazwa;

    void _incrementCounter(){
      setState((){
        if (_counter<5){
          _counter++;
          }
        else {_counter=0;}
      }          
      );
    }
    
  
    
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: widget.kolor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(widget.nazwa, style: Theme.of(context,).textTheme.headlineMedium!.copyWith(color: Colors.white),),
        SizedBox(width: 50,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 210, 176, 230),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _incrementCounter,
              child: Text('$_counter',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),),],),
    );
    
  }
  }
  
  
