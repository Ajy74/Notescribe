
import 'package:flutter/material.dart';

const Color primaryColor =  Color(0xFF7F2862);
const Color darkText =  Color(0xFF191919);
const Color bluishWhite =  Color.fromARGB(255, 240, 237, 255);

LinearGradient lightGradient(){
  return LinearGradient(
    colors: [
      primaryColor.withOpacity(.2),
      primaryColor.withOpacity(.1),
      primaryColor.withOpacity(.02),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}

LinearGradient noteGradient1(){
  return const LinearGradient(
    colors: [
      Color(0xFFf89999),
      Color(0xFFf6c0ba),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}

LinearGradient noteGradient2(){
  return const LinearGradient(
    colors: [
      Color(0xFFf1e1c2),
      Color(0xFFfcbc98),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}

LinearGradient noteGradient3(){
  return const LinearGradient(
    colors: [
      Color(0xFFf9cdc3),
      Color(0xFFfacefb),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}

LinearGradient noteGradient4(){
  return const LinearGradient(
    colors: [
      Color(0xFFfbd07c),
      Color(0xFFf7f779),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}

List<LinearGradient> noteGradient = [
  noteGradient1(),
  noteGradient2(),
  noteGradient3(),
  noteGradient4(),
];