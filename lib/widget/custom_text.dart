import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight? fontWeight;

  const ModifiedText({Key? key, required this.text, required this.color,required this.size, this.fontWeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: GoogleFonts.aclonica(color: color, fontSize:size,fontWeight: fontWeight),
      textAlign: TextAlign.center,
      // overflow: TextOverflow.ellipsis,
    );
  }
}

class ModifiedSingleLineText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight? fontWeight;

  const ModifiedSingleLineText({Key? key, required this.text, required this.color,required this.size, this.fontWeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: GoogleFonts.aclonica(color: color, fontSize:size,fontWeight: fontWeight),
      // textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}