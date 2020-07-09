import 'package:dictionarytranslatorapp/screens/dictionary.dart';
import 'file:///G:/esunb/Github/dictionary_translator_app/lib/screens/translator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyTranslator());
}

class MyTranslator extends StatefulWidget{
  @override
  _MyTranslatorState createState() => _MyTranslatorState();
}

class _MyTranslatorState extends State<MyTranslator> {
  int selectedIndex = 1;
  List<Widget> pageList = [Translator(), Dictionary()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pageList[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text("Translator"),
              icon: Icon(Icons.text_fields),
            ),
            BottomNavigationBarItem(
              title: Text("Translator"),
              icon: Icon(Icons.library_books),
            ),
          ],
          onTap: (index){
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
