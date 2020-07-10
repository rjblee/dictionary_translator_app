import 'package:flutter/material.dart';

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "798c2e0afa8901dc9a9b02c64fab8a39c5e9394e";

  TextEditingController _controller = TextEditingController();

  _search() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dictionary"),
          backgroundColor: Colors.blueAccent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextFormField(
                      onChanged: (String text) {},
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search for a Word",
                        contentPadding: EdgeInsets.only(left: 24),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _search();
                  },
                )
              ],
            ),
          ),
        ),
        body: StreamBuilder(builder: null),
      ),
    );
  }
}
