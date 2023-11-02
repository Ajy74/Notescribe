
import 'dart:io';

import 'package:intl/intl.dart';

List notesCategory = [
  "All Notes",
  "General",
  "Important",
  "Urgent",
  "Personel",
  "Work",
  "College",
  "Study",
  "Shoping",
  "Medicine",
  "Entertainment",
];

List frontImages = [
  "assets/icons/no_3.jpg",
  "assets/icons/no_4.jpg",
  "assets/icons/no_5.jpg",
  "assets/icons/no_6.jpg",
  "assets/icons/no_7.jpg",
  "assets/icons/no_8.jpg",
  "assets/icons/no_9.jpg",
  "assets/icons/no_10.jpg",
  "assets/icons/no_11.jpg",
  "assets/icons/no_12.jpg",
  "assets/icons/no_13.jpg",
  "assets/icons/no_14.jpg",
];

String getDate(String date){
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String getYearDate(String date){
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('yyyy').format(dateTime);
}

String getShortDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('d MMM', 'en_US').format(dateTime);
  return formattedDate;
}

void deleteFromFile(String path) async{
  File fileToDelete = File('$path');

  // final dir = await path_provider.getTemporaryDirectory();
  // final targetPath = '${dir.absolute.path}/${DateTime.now()}.jpg';

  if (fileToDelete.existsSync()) {
    // fileToDelete.deleteSync();
    await fileToDelete.delete();
    print('File deleted successfully.');
  } else {
    print('File does not exist.');
  }
}