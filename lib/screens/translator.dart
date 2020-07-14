import 'dart:math';
import 'package:dictionarytranslatorapp/widgets/language-list-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  TextEditingController _starLangController = TextEditingController();
  String startText;
  String translatedText = '';
  List<ListItem> _dropdownItems = [
    ListItem('en', "English"),
    ListItem('es', "Spain"),
    ListItem('ko', "Korean"),
    ListItem('fr', "France"),
    ListItem('ja', "Japanese"),
    ListItem('zu', "China"),
    ListItem('cs', "Czech"),
    ListItem('fh', "Thailand"),
    ListItem('ar', "Arabic"),
    ListItem('el', "Greece"),
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedCurrentLang;
  ListItem _selectedTargetLang;

  final SpeechToText speech = SpeechToText();
  String outputText = '';
  bool _hasSpeech = false;
  String _currentLocateId = 'en_IN';
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedCurrentLang = _dropdownMenuItems[0].value;
    currentLang = _dropdownMenuItems[0].value.value;
    _selectedTargetLang = _dropdownMenuItems[2].value;
    targetLang = _dropdownMenuItems[2].value.value;

    initSpeechState();
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<String> translateIt() async {
    setState(() {
      startText = _starLangController.text;
    });
    var text = await translator.translate(
      startText,
      to: targetLang,
    );

    setState(() {
      translatedText = text;
    });

    return text;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          color: Color(0xff001c2f),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                  child: Text("Voice translate",
                      style: TextStyle(color: Colors.white))),
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                icon: Icon(
                  Icons.settings_voice,
                  color: _hasSpeech ? Colors.blue : Colors.white,
                ),
                onPressed: () {
                  !_hasSpeech || speech.isListening ? null : startListening();
                },
              ),
            ],
          ),
        ),
        Container(
          color: Color(0XFFc8dcfd),
          child: Container(
            width: size.width,
            height:
                visualAreaHeight != null ? visualAreaHeight : size.height * 0.2,
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
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<ListItem>(
                        value: _selectedCurrentLang,
                        items: _dropdownMenuItems,
                        onChanged: (value) async {
                          await translateIt();
                          setState(() {
                            _selectedCurrentLang = value;
                            currentLang = value.value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: size.width,
                  color: Color(0XFFc8dcfd),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 4,
                    maxLengthEnforced: true,
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
                        visualAreaHeight = size.height * 0.05;
                      });
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();

                      translateIt();
                      setState(() {
                        visualAreaHeight = size.height * 0.3;
                      });
                    },
                    onFieldSubmitted: (string) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  color: Color(0XFFc8dcfd),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: FlatButton(
                  child: Text("Submit"),
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    translateIt();
                    setState(() {
                      visualAreaHeight = size.height * 0.22;
                    });
                  },
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
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<ListItem>(
                        value: _selectedTargetLang,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedTargetLang = value;
                            targetLang = value.value;
                          });

                          translateIt();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SelectableText(
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
    );
  }

  void initSpeechState() async {
    print("start");
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
//      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocateId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void statusListener(String status) {
    print(status);
  }

  void errorListener(SpeechRecognitionError errorNotification) {
    print(errorNotification);
  }

  startListening() {
    print("start1111");

    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocateId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
  }

  void resultListener(SpeechRecognitionResult result) {
    print("outputText : $result");

    if (result.finalResult)
      setState(() {
        outputText = result.recognizedWords;
        _starLangController.text = outputText;
        print("outputText : $outputText");
      });
  }

  soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);

    setState(() {
      this.level = level;
    });
  }
}
