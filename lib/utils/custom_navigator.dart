import 'package:flutter/material.dart';

customPushScreen(BuildContext context, Widget widget){
  Navigator.push(
    context,
    customPageRouteBuilder(
      widget, 
      transitionDuration: const Duration(milliseconds: 250),
    ),
  );
}

customPushAndOffAllScreen(BuildContext context, Widget widget){
  Navigator.push(
    context,
    customPageRouteBuilder(
      widget, 
      transitionDuration: const Duration(milliseconds: 250),
    ),
  );
}

PageRouteBuilder customPageRouteBuilder(Widget page, {required Duration transitionDuration}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: transitionDuration,
  );
}