import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notescribe/screens/home_screen.dart';
import 'package:notescribe/utils/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark, 
    ));
    return MaterialApp(
      title: 'Notescribe',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData( 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: primaryColor.withOpacity(.2), // Set the custom selection color
          selectionHandleColor: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
        fontFamily: GoogleFonts.roboto().fontFamily
      ),
      home: const HomeScreen(),
      // home: const NoteEditorScreen(),
    );
  }
}


// Function to create a MaterialColor from a single color
MaterialColor createMaterialColor(Color color) {
  List<Color> shades = [
    color,
    Color.lerp(color, Colors.black, 0.1)!,
    Color.lerp(color, Colors.black, 0.2)!,
    Color.lerp(color, Colors.black, 0.3)!,
    Color.lerp(color, Colors.black, 0.4)!,
    Color.lerp(color, Colors.black, 0.5)!,
    Color.lerp(color, Colors.black, 0.6)!,
    Color.lerp(color, Colors.black, 0.7)!,
    Color.lerp(color, Colors.black, 0.8)!,
    Color.lerp(color, Colors.black, 0.9)!,
  ];

  return MaterialColor(color.value, {
    50: shades[0],
    100: shades[1],
    200: shades[2],
    300: shades[3],
    400: shades[4],
    500: shades[5],
    600: shades[6],
    700: shades[7],
    800: shades[8],
    900: shades[9],
  });
}


