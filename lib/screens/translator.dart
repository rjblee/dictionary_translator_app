import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:translator/translator.dart';

class Translator extends StatefulWidget {
  @override
  _TranslatorState createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  final translator = new GoogleTranslator();
  double visualAreaHeight;
  String currentLang;
  String targetLang;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _starLangController = TextEditingController();
  TextEditingController _targetController = TextEditingController();
  String startText;
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<String> translateIt() async {
      setState(() {
        startText = _starLangController.text;
      });
      var text = await translator.translate(
        startText,
        to: 'pt',
      );

      return text;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            color: Color(0XFFc8dcfd),
            child: Container(
              width: size.width,
              height: visualAreaHeight != null
                  ? visualAreaHeight
                  : size.height * 0.3,
              decoration: BoxDecoration(
                color: Color(0xff001c2f),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Image.asset(
                "assets/images/recording.gif",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  color: Color(0xff001c2f),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFFc8dcfd),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.text_fields),
                        DropdownButton(value: "English", items: [
                          DropdownMenuItem<String>(
                            value: "English",
                            child: Text("English"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Englis2h",
                            child: Text("Englis2h"),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    color: Color(0XFFc8dcfd),
                    child: TextFormField(
                      controller: _starLangController,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: "Start Language",
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        setState(() {
                          visualAreaHeight = size.height * 0.1;
                        });
                      },
                      onEditingComplete: () async {
                        var text = await translateIt();
                        setState(() {
                          translatedText = "";
                          translatedText = text;
                          visualAreaHeight = size.height * 0.3;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0XFFc8dcfd),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  color: Color(0XFFc8dcfd),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.text_fields),
                        DropdownButton(value: "English", items: [
                          DropdownMenuItem<String>(
                            value: "English",
                            child: Text("English"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Englis2h",
                            child: Text("Englis2h"),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    translatedText != null ? translatedText : "Target Language",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
