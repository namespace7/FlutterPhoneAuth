import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:liveasy/main.dart';

class LanguageSelect extends StatefulWidget {
  const LanguageSelect({Key? key}) : super(key: key);

  @override
  _LanguageSelectState createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {

  String dropDownValue = 'English';
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
          body: Column(
            children: <Widget> [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 170.0, right: 20.0),
                  //child: Image.asset("assets/icon.jpg",height: 450,width: 100),
                  child: const Icon(Icons.airport_shuttle),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: const Text('Please select your Language',textScaleFactor: 1.6,),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: const Text('You can change the language at anytime',textScaleFactor: 0.9 ,),
              ),


            DropdownButton<String>(
              value: dropDownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
              setState(() {
              dropDownValue = newValue!;
              });
              },
              items: <String>['English', 'Hindi',]
                  .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
              );
              }).toList(),
            ),
            Container(
              width: 256,
              height: 48,
              margin: const EdgeInsets.all(48),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Expanded(child: Center(child: Text('NEXT'))),
                   ],
                    ),
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')));
                  log('button clicked');
                },
             ),
            ),

            ],
          )
      ),
    );
  }
}