import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black54,
      title: Text(
        "Firebook",
        style: GoogleFonts.raleway(fontSize: 20, color: Colors.lightBlueAccent),
      ));
}

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
