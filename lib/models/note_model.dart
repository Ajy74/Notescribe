
import 'dart:convert';

final String tableNotes = 'notes' ;

class Note{
  int? id;
  int? isImportant ;
  String? category;
  String? title;
  String? description;
  String? plainText;
  String? createdTime;
  List<String>? links;
  List<String>? images;

  Note({
    this.id,
    required this.isImportant,
    required this.category,
    required this.title,
    required this.description,
    required this.plainText,
    required this.createdTime,
    this.links,
    this.images,
  });



  Note.fromJson(Map<String, dynamic> json){
    id=json['id'];
    isImportant = json['isImportant'];
    title = json['title'];
    category = json['category'];
    description = json['description'];
    createdTime = json['createdTime'];
  }


  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id']=this.id;
    data['title']=this.title;
    data['category']=this.category;
    data['description']=this.description;
    data['createdTime']=this.createdTime;
   
    return data;
  }


  Note.fromMap(Map<String, dynamic> res){
    id=res['id'];
    isImportant = res['isImportant'];
    title = res['title'];
    category = res['category'];
    description = res['description'];
    plainText = res['plainText'];
    createdTime = res['createdTime'];
    links = jsonDecode(res['links']).cast<String>();
    images = jsonDecode(res['images']).cast<String>();
  }


  Map<String, Object?> toMap(){
    
    return {
      'id' : id,
      'isImportant' : isImportant,
      'title' : title,
      'category' : category,
      'description' : description,
      'plainText' : plainText,
      'createdTime' : createdTime,
      'links': jsonEncode(links),  // Serialize list to JSON
      'images': jsonEncode(images),  // Serialize list to JSON
    };
  }



}