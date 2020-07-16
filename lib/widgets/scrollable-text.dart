
import 'package:flutter/material.dart';

class ScrollableText extends StatelessWidget {
  String text;

  ScrollableText({this.text});
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SelectableText(
              text != null ? text : "Translate to...",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
              ),
            ),
          ),
        ]
    );
  }
}
