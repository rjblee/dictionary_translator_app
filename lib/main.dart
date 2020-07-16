import 'package:dictionarytranslatorapp/screens/dictionary.dart';
import 'package:dictionarytranslatorapp/screens/translator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyTranslator());
}

class MyTranslator extends StatefulWidget {
  @override
  _MyTranslatorState createState() => _MyTranslatorState();
}

class _MyTranslatorState extends State<MyTranslator> {
  int _selectedIndex = 0;
  static List<Widget> _pageList = <Widget>[Translator(), Dictionary()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff001c2f),
          elevation: 0,
          leading: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        body: _pageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text(
                "Translator",
                style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey[600],
                ),
              ),
              icon: Icon(
                Icons.text_fields,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey[600],
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                "Dictionary",
                style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey[600],
                ),
              ),
              icon: Icon(
                Icons.library_books,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
