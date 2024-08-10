// import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:math';

// import 'package:flutter/gestures.dart';
import 'package:flip_card/flip_card.dart';
// import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notescribe/Db/db_helper.dart';
import 'package:notescribe/models/note_model.dart';
import 'package:notescribe/screens/note_editor_screen.dart';
import 'package:notescribe/screens/search_screen.dart';
import 'package:notescribe/utils/color.dart';
import 'package:notescribe/utils/constant.dart';
import 'package:notescribe/utils/custom_navigator.dart';
import 'package:notescribe/widget/circular_checkbox.dart';
import 'package:notescribe/widget/custom_button.dart';
import 'package:notescribe/widget/custom_text.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbHelper ;
  late Future<List<Note>> notelist ;

  String category = "All Notes" ;

  bool isNoteSelected = false ;
  bool isAllNoteSelected = false ;
  List selectedNotesIds = [] ;
  AsyncSnapshot<List<Note>>? allSnapshot ;
  int count = 0 ;

  
  // late List<GlobalKey<FlipCardState>> _cardKeys ;
  // late FlipCardController flipCardController;
  bool isFlipAll = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
    loadData();
    
    // flipCardController = FlipCardController();
  }

  loadData() async{
    notelist = dbHelper!.getNotesList() ;

    //^ get count of all note
    List<Note> notes = await notelist;
    count = notes.length;

    // _cardKeys = List.generate(
    //   count,
    //   (index) => GlobalKey<FlipCardState>(),
    // );
    setState(() {    });
  }

  @override
  Widget build(BuildContext context) {
    // if(count > 0 ){
    //   _cardKeys.clear();
    //   _cardKeys = List.generate(
    //     count,
    //     (index) => GlobalKey<FlipCardState>(),
    //   );
    //   print(_cardKeys.length);
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: lightGradient()
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Premium Features Coming Soon !",
                    textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                backgroundColor: Colors.orange,
              ),
            );
          },
          // child: const Icon(Icons.person_pin,size: 45,color: primaryColor,),
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              radius: 22,
              child: ClipOval(clipBehavior: Clip.hardEdge,child: Image.asset("assets/icons/appicon.png")),
            ),
          ),
        ),
        title: const Text(
          "Hi, Guest User",
          style: TextStyle(color: primaryColor,fontSize: 23)
        ),
        actions: [
          const SizedBox(width: 10,),

          if(!isNoteSelected)
            GestureDetector(
              onTap: (){
                customPushScreen(context, SearchScreen());
              },
              child: const Icon(Icons.search,size: 35,color: primaryColor,)
            ),
       
          if(isNoteSelected)
            ResizableCircularCheckbox(
              value: isAllNoteSelected, 
              onChanged: (value) {
                if(!isAllNoteSelected){
                  Vibration.vibrate(duration: 70);
                  for(int i=0; i< allSnapshot!.data!.length ; i++){
                    if(category != "All Notes"){
                      if(category == allSnapshot!.data![i].category){
                        selectedNotesIds.add(allSnapshot!.data![i].id);
                      }
                    }
                    else{
                      selectedNotesIds.add(allSnapshot!.data![i].id);
                    }
                  }
                  isAllNoteSelected = true;
                  setState(() { });
                }
                else{
                  selectedNotesIds.clear();
                  isAllNoteSelected = false;
                  setState(() { });
                }
              }, 
              size: 25
            ),
          const SizedBox(width: 15,)
        ],
      ),

      // body: Container(
        
      //   child: CustomScrollView(
      //     slivers: [
      //       //& Main Heading(Noteboo name)
      //       SliverAppBar(
      //         stretch: true,
      //         backgroundColor: Colors.transparent,
      //         bottom: const PreferredSize(preferredSize: Size.fromHeight(-8.0), child: SizedBox()),
      //         flexibleSpace: Container(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //                 Container(
      //                   margin: const EdgeInsets.only(left: 10,right: 10,top: 12),
      //                   child: ModifiedSingleLineText(
      //                     text: "All Notes", 
      //                     color: primaryColor, 
      //                     size: 32
      //                   )
      //                 ),
      //                 // Row(
      //                 //   children: [
      //                 //     Container(
      //                 //       margin: const EdgeInsets.symmetric(horizontal: 10),
      //                 //       child: ModifiedSingleLineText(
      //                 //         text: "10 Notes", 
      //                 //         color: primaryColor, 
      //                 //         size: 14
      //                 //       )
      //                 //     ),
      //                 //     const Spacer(),
      //                 //     Container(
      //                 //       margin: const EdgeInsets.symmetric(horizontal: 10),
      //                 //       // child: ModifiedSingleLineText(
      //                 //       //   text: "flip all", 
      //                 //       //   color: darkText, 
      //                 //       //   size: 15
      //                 //       // )
      //                 //       child:const Text(
      //                 //         "Flip all",
      //                 //         style: TextStyle(color: darkText,fontWeight: FontWeight.bold,fontSize: 13,letterSpacing: 1)
      //                 //       ),
      //                 //     ),
      //                 //   ],
      //                 // )
            
      //             ],
      //           ),
      //         ),
      //       ),
      //       SliverAppBar(
      //         stretch: true,
      //         backgroundColor: Colors.transparent,
      //         bottom: const PreferredSize(preferredSize: Size.fromHeight(-35.0), child: SizedBox()),
      //         flexibleSpace: Container(
      //           child: Row(
      //             children: [
      //               Container(
      //                 margin: const EdgeInsets.symmetric(horizontal: 10),
      //                 child: const ModifiedSingleLineText(
      //                   text: "10 Notes", 
      //                   color: primaryColor, 
      //                   size: 14
      //                 )
      //               ),
      //               const Spacer(),
      //               Container(
      //                 margin: const EdgeInsets.symmetric(horizontal: 10),
      //                 // child: ModifiedSingleLineText(
      //                 //   text: "flip all", 
      //                 //   color: darkText, 
      //                 //   size: 15
      //                 // )
      //                 child:const Text(
      //                   "Flip all",
      //                   style: TextStyle(color: darkText,fontWeight: FontWeight.bold,fontSize: 13,letterSpacing: 1)
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
            
      //       const SliverAppBar(
      //         stretch: true,
      //         backgroundColor: Colors.white,
      //         pinned: true,
      //         bottom: PreferredSize(preferredSize: Size.fromHeight(-40.0), child: SizedBox()),
      //       ),
            
      //       //^ search bar
      //       SliverAppBar(
      //         pinned: true,
      //         elevation: 0,
      //         backgroundColor: Colors.white,
      //         // bottom: const PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(-7.0)),
      //         flexibleSpace: Container(
      //           margin: const EdgeInsets.symmetric(horizontal: 10),
      //           child: TextField(
      //             style: const TextStyle(fontSize: 18),
      //             decoration: InputDecoration(
      //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      //               prefixIcon: const Icon(Icons.search),
      //               hintMaxLines: 1,
      //               hintText: "search notes",
      //               hintStyle: const TextStyle(fontSize: 18),
      //             ),
      //           ),
      //         ),
      //       ),
            
      //       // const SliverAppBar(
      //       //   stretch: true,
      //       //   backgroundColor: Colors.white,
      //       //   pinned: true,
      //       //   bottom: PreferredSize(preferredSize: Size.fromHeight(-40.0), child: SizedBox()),
      //       // ),
            
      //       //& list items     
            
      //       // SliverGrid.builder(
      //       //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       //     crossAxisCount: 2,
      //       //     mainAxisSpacing: 2,
      //       //     crossAxisSpacing: 10,
      //       //     childAspectRatio: 3/2
      //       //   ),
      //       //   itemCount: 20,
      //       //   itemBuilder: (context, index) {
      //       //     return Container(
      //       //       margin: EdgeInsets.symmetric(vertical: 5),
      //       //       height: index%2==0 ? 200 : 100,
      //       //       color: Colors.amber,
      //       //     );
      //       //   },
      //       // ),

                        
      //       SliverToBoxAdapter(
      //         child: Container(
      //           height: 200,
      //           color: Colors.amber,
      //           child: MasonryGridView.count(
      //             clipBehavior: Clip.antiAliasWithSaveLayer,
      //             crossAxisCount: 2,
      //             mainAxisSpacing: 4,
      //             crossAxisSpacing: 4,
      //             itemCount: 20,
      //             itemBuilder: (context, index) {
      //               return Container(
      //                   color: Colors.red,
      //                   height: index.isEven ? 100 : 200,
      //               );
      //             },
      //           ),
      //         )
      //       )
           
            
      //     ],
      //   ),
      // ),

      body: 
       WillPopScope(
        onWillPop: () async{
          return exit(0);
        },
         child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //& Main Heading(Noteboo name)
              Builder(
                builder: (context){
                  return Container(
                    margin: const EdgeInsets.only(left: 10,right: 10,top: 12),
                    child: GestureDetector(
                      onTap: (){
                        _showButtomSheet(context);
                      },
                      child: ModifiedSingleLineText(
                        text: category, 
                        color: primaryColor, 
                        size: 32
                      ),
                    )
                  );
                },
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ModifiedSingleLineText(
                      text: "$count Notes", 
                      color: primaryColor, 
                      size: 14
                    )
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    // child: ModifiedSingleLineText(
                    //   text: "flip all", 
                    //   color: darkText, 
                    //   size: 15
                    // )
                    // child:GestureDetector(
                    //   onTap: (){
                    //     for (var key in _cardKeys) {
                    //       key.currentState?.toggleCard();
                    //     }
                    //   },
                    //   child: Text(
                    //      isFlipAll ? "Flip back" :"Flip all",
                    //      style: const TextStyle(color: darkText,fontWeight: FontWeight.bold,fontSize: 13,letterSpacing: 1)
                    //   ),
                    // ),
                  ),
                ],
              ),
         
              const SizedBox(height: 17,),
         
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
                          return flipContainer(snapshot,index);
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
         
            ],
          ),
               ),
       ), 
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: FloatingActionButton(
          backgroundColor: primaryColor.withOpacity(.2),
          splashColor: primaryColor.withOpacity(.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: const Icon(Icons.draw,color: primaryColor,size: 30,),
          onPressed: (){
           customPushScreen(context, NoteEditorScreen(type: "new",)); //new_old
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      persistentFooterButtons: isNoteSelected ? <Widget>[
          const SizedBox(width: 5,),
          Container(
            width: MediaQuery.of(context).size.width/2.5,
            child: CustomButton(
              title: "Delete", 
              letterSpacing: 1,
              radius: 30,
              onPress: () async{
                //^ delete all selected notes 
                for (var id in selectedNotesIds){
                    dbHelper!.delete(id);
                }

                if(category != "All Notes"){
                  notelist = dbHelper!.getCategoryNotesList(category) ;
                }else{
                  notelist = dbHelper!.getNotesList() ;
                }
  
                //^ get count of category note
                List<Note> notes = await notelist;
                count = notes.length;
                setState(() {
                  isAllNoteSelected = false;
                  isNoteSelected = false;
                });
              }
            )
          ),

          const SizedBox(width: 5,),

          Container(
            width: MediaQuery.of(context).size.width/2.5,
            child: CustomButton(
              title: "Cancel", 
              letterSpacing: 1,
              radius: 30,
              buttonColor: primaryColor.withOpacity(.2),
              textColor: primaryColor,
              onPress: (){
                setState(() {
                  isNoteSelected = false;
                  isAllNoteSelected = false;
                });
              }
            )
          ),
          const SizedBox(width: 5,),
        ] : null,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
  
  _showButtomSheet(BuildContext context) {
    showBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height/1.8,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: bluishWhite,
            border: Border.all(color: primaryColor),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                child: horizontalLine(2, 60),
              ),
              const SizedBox(height: 10,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const ModifiedSingleLineText(
                  text: "Choose Categeory", 
                  color: primaryColor, 
                  size: 21
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: notesCategory.length,
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              category = notesCategory[index];
                              if(category != "All Notes"){
                                  notelist = dbHelper!.getCategoryNotesList(notesCategory[index]) ;
                              
                                  //^ get count of category note
                                  List<Note> notes = await notelist;
                                  count = notes.length;
                              }
                              else{
                                notelist = dbHelper!.getNotesList() ;

                                //^ get count of all note
                                List<Note> notes = await notelist;
                                count = notes.length;
                              }

                              setState(() {
                                Navigator.pop(context);                                 
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child:  ModifiedSingleLineText(
                                text: notesCategory[index], 
                                color: primaryColor, 
                                size: 17
                              ),
                            ),
                          ),
                          horizontalLine(1, double.maxFinite),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        );
      }
    );
  }

  horizontalLine(double height , double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: height,
      width: width,
      color: primaryColor,
    );
  }
  
  notesCard(int index, AsyncSnapshot<List<Note>>? snapshot) {
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isNoteSelected)
          Container(
            alignment: Alignment.centerRight,
            child: ResizableCircularCheckbox(
              value: selectedNotesIds.contains(snapshot?.data?[index].id), 
              onChanged: (value) {
                
              }, 
              size: 21
            ),
          ),

        Container(
          child: Text(snapshot!.data![index].title.toString(), style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.purple,
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
  
  notesFrontCard(int index, AsyncSnapshot<List<Note>> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: ModifiedSingleLineText(
            text: snapshot.data![index].title!, 
            color: Colors.white, 
            size: 21
          ),
        ),
        const SizedBox(height: 8,),
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: ModifiedSingleLineText(
            text: getYearDate(snapshot.data![index].createdTime!), 
            color: Colors.white, 
            size: 22
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: ModifiedSingleLineText(
            text: getShortDate(snapshot.data![index].createdTime!), 
            color: Colors.white, 
            size: 30
          ),
        ),
      ],
    );
  }
  
  flipContainer(AsyncSnapshot<List<Note>> snapshot, int index) {
    
    return FlipCard(
      fill: Fill.fillFront, 
      // key: _cardKeys[index],
      // controller: flipCardController,
      alignment: FractionalOffset.topCenter,
      direction: FlipDirection.HORIZONTAL, // default
      side: CardSide.FRONT, 
      front: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 7),
        height: 200,
        // height: index.isEven ? 200 : 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:  noteGradient[Random().nextInt(noteGradient.length)],
          image: DecorationImage(
            image: AssetImage(frontImages[Random().nextInt(frontImages.length)]),
            fit: BoxFit.cover,
            // opacity: .9
          )
        ),
        child: snapshot.data == null ? const Center(child: CircularProgressIndicator(color: primaryColor),) : notesFrontCard(index,snapshot),
      ),
      back: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onLongPress: (){
            Vibration.vibrate(duration: 100);
        
            allSnapshot = snapshot ;
        
            selectedNotesIds.clear();
            setState(() {
              isNoteSelected = true ;
            });
          },
          onTap: (){
            if(isNoteSelected){
              if(selectedNotesIds.contains(snapshot.data![index].id)){
                setState(() {
                  selectedNotesIds.remove(snapshot.data![index].id!);
                });
              }
              else{
                Vibration.vibrate(duration: 50);
                setState(() {
                  selectedNotesIds.add(snapshot.data![index].id!);
                });
              }
            }
        
            if(!isNoteSelected){
              customPushScreen(
                context, 
                NoteEditorScreen(
                  noteId: snapshot.data![index].id,
                  type: "old",
                  category: category,
                  heading: snapshot.data![index].title,
                  notes: snapshot.data![index].description,
                  imageLinks: snapshot.data![index].images,
                  noteLinks: snapshot.data![index].links,
                  isPinned: snapshot.data![index].isImportant,
                )
              );
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 145),
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 7),
              // height: index.isEven ? 100 : 200,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(20),
                color: primaryColor.withOpacity(.1),
                    
                // gradient:  noteGradient[Random().nextInt(noteGradient.length)]
              ),
              child: snapshot.data == null ? const Center(child: CircularProgressIndicator(color: primaryColor),) : notesCard(index,snapshot),
            ),
          ),
        ),
      ),
    );
  }
  

}