import 'package:flutter/material.dart';
import 'package:notescribe/utils/color.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonColor = primaryColor,
    this.textColor = Colors.white,
    required this.title ,
    required this.onPress ,
    this.width = 75 ,
    this.height = 50 ,
    this.loading = false ,
    this.radius = 10 ,
    this.textSize = 16,
    this.letterSpacing = 0,
  });

  final bool loading;
  final String title;
  final double height,width;
  final VoidCallback onPress;
  final Color textColor,buttonColor;
  final double textSize;
  final double radius;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,

      child: Container(
    
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
    
        child: loading ? 
        const Center(
          child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            ),
        )
        ) :
        Center(
          child: Text(title, style: TextStyle(color: textColor,fontSize: textSize,letterSpacing: letterSpacing,fontWeight: FontWeight.w700), ),
        ) ,
    
      ),
    );
  }
}