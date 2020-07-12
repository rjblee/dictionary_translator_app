import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart';

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "798c2e0afa8901dc9a9b02c64fab8a39c5e9394e";

  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

//    if (_controller.text == int) {
//      _streamController.add("No searches found");
//    }

    _streamController.add("waiting");

    Response response = await get(_url + _controller.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Dictionary")),
          backgroundColor: Color(0xff001c2f),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Neumorphic(
                    margin: EdgeInsets.only(left: 18, bottom: 14),
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      lightSource: LightSource.bottom,
                      color: Colors.white,
                      depth: 10,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(24),
                      ),
                    ),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(24),
//                    ),
                    child: TextFormField(
                      onChanged: (String text) {
                        if (_debounce?.isActive ?? false) _debounce.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 2000), () {
                          _search();
                        });
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search for a Word",
                        contentPadding: EdgeInsets.only(left: 34),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () {
                    _search();
                  },
                )
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: StreamBuilder(
            stream: _stream,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text("Enter a search word"),
                );
              }

              if (snapshot.data == "waiting") {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListBody(
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          lightSource: LightSource.top,
                          color: Colors.blue[100],
                          depth: 5,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(24),
                          ),
                        ), //                        decoration: BoxDecoration(
//                          color: Colors.blueGrey[200],
//                          borderRadius: BorderRadius.circular(18),
//                        ),
                        child: ListTile(
                          leading: snapshot.data["definitions"][index]
                                      ["image_url"] ==
                                  null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data["definitions"][index]["image_url"]),
                                ),
                          title: Text(_controller.text.trim() +
                              " (" +
                              snapshot.data["definitions"][index]["type"] +
                              ")"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Definition: " +
                              snapshot.data["definitions"][index]["definition"],
                          style: TextStyle(
                            fontSize: 18,
//                            fontFamily: 'Raleway',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Example: \"" +
                              snapshot.data["definitions"][index]["example"] +
                              "\"",
                          style: TextStyle(
                            fontSize: 18,
//                            fontFamily: 'Raleway',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
