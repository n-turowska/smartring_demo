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
            MainShape(kolor:Colors.blueGrey ,nazwa: "Dobowy HRV: 40ms"),
            Stres(kolor: Colors.blueGrey ,nazwa: "Jak bardzo się dziś stresujesz: ",),
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
    State<Stres> createState() => _poziom_stresu();
  }

  class _poziom_stresu extends State<Stres>{
    int _counter = 0;
    
     late final dynamic kolor;
      late final dynamic nazwa;

    void _incrementCounter(){
      setState((){
        _counter++;
      });
    }
  
    
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kolor,
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
      child: Column(
        children: [
        Text(nazwa, style: Theme.of(context,).textTheme.headlineMedium!.copyWith(color: Colors.white),),
        ElevatedButton(onPressed:_incrementCounter, child:Text('$_counter'),) ])
    );
    
  }
  }
  
  
