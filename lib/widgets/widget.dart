import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black54,
    title: Text("Let's Chat",style: GoogleFonts.lato(fontSize: 20,color: Colors.deepOrangeAccent),)
  );
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
