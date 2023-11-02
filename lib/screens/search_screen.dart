import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notescribe/Db/db_helper.dart';
import 'package:notescribe/models/note_model.dart';
import 'package:notescribe/screens/note_editor_screen.dart';
import 'package:notescribe/utils/color.dart';
import 'package:notescribe/utils/constant.dart';
import 'package:notescribe/utils/custom_navigator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();

  DBHelper? dbHelper ;
  late Future<List<Note>> notelist ;
  int count = 0 ;
  String searchText = " " ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
    loadData();
  }

  loadData() async{
    notelist = dbHelper!.getNotesList() ;

    //^ get count of all note
    List<Note> notes = await notelist;
    count = notes.length;
    setState(() {    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: lightGradient()
          ),
        ),
        title: const Text(
          "Search Notes",
          style: TextStyle(color: primaryColor,fontSize: 23)
        ),
      ),

      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 10,),

            //^ search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 55,
              child:searchRow()
            ),

            const SizedBox(height: 10,),

           //& staggered grid view
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: 
                count > 0 ?
                FutureBuilder(
                  future: notelist,
                  builder: (context, AsyncSnapshot<List<Note>> snapshot){
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 8,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                      
                        return 
                        snapshot.data != null ?
                          ( snapshot.data![index].title!.toLowerCase().contains(searchText.toLowerCase()) || snapshot.data![index].plainText!.toLowerCase().contains(searchText.toLowerCase()) ||  snapshot.data![index].createdTime!.toLowerCase().contains(searchText.toLowerCase()) ) ?
                            GestureDetector(
                              onTap: (){
                                customPushScreen(
                                  context, 
                                  NoteEditorScreen(
                                    noteId: snapshot.data![index].id,
                                    type: "old",
                                    category: snapshot.data![index].category,
                                    heading: snapshot.data![index].title,
                                    notes: snapshot.data![index].description,
                                    imageLinks: snapshot.data![index].images,
                                    noteLinks: snapshot.data![index].links,
                                    isPinned: snapshot.data![index].isImportant,
                                  )
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 7),
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                  color: primaryColor.withOpacity(.1),
                                ),
                                child: snapshot.data == null ? const SizedBox() : notesCard(index,snapshot),
                              ),
                            ) : const SizedBox()
                        : const Center(child: CircularProgressIndicator(),);
                      },
                    );
                  },
                ) 
                : Container(
                  alignment: Alignment.center,
                  child: Container(
                    child: Center(
                      child: Image.asset("assets/icons/empty.png",height: 250,width: 250,),
                    ),
                  ),
                ),
              ), 
            ),
            
            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }

  searchRow() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor.withOpacity(.1)
      ),
      child: TextFormField(
        controller: searchController,
        keyboardType: TextInputType.text,
        onChanged: (value){
          setState(() {
            searchText = value.characters.toString();
          });
        },
        style: const TextStyle(color: primaryColor,fontSize: 17),
        decoration: InputDecoration(
          hintText: "search",
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: const TextStyle(color: darkText,fontSize: 20),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/icons/serch.png",color: primaryColor,),
          ),
        ),
      ),
    );
  }
  
  notesCard(int index, AsyncSnapshot<List<Note>>? snapshot) {
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          child: Text(snapshot!.data![index].title.toString(), style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.purple
          ),),
        ),

        const SizedBox(height: 9,),

        Container(
          // height: 100,
          child: Text(
            snapshot.data![index].plainText.toString().trim(),
            overflow: TextOverflow.ellipsis,
            maxLines:6,
            style: const TextStyle(fontSize: 14),
          )
        ),

        const SizedBox(height: 9,),

        snapshot.data![index].images!.isNotEmpty ? 
          Container(
            width: double.maxFinite,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(snapshot.data![index].images![0]),fit: BoxFit.fill,)
            ),
          )
        : SizedBox() ,

        const SizedBox(height: 9,),

        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 9),
          child: Text(
            getDate(snapshot.data![index].createdTime.toString().trim()),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.purple),
          )
        ),

      ],
    );
  }

}