import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notescribe/Db/db_helper.dart';
import 'package:notescribe/models/note_model.dart';
import 'package:notescribe/screens/home_screen.dart';
import 'package:notescribe/utils/color.dart';
import 'package:notescribe/utils/constant.dart';
import 'package:notescribe/utils/custom_navigator.dart';
import 'package:notescribe/widget/custom_text.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as path_provider ;

// import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class NoteEditorScreen extends StatefulWidget {
  NoteEditorScreen({
    required this.type, 
    this.noteId,
    this.category, 
    this.heading, 
    this.notes ,
    this.isPinned,
    this.noteLinks,
    this.imageLinks,
    super.key
  });

  String? category;
  String? heading;
  String? notes;
  int? noteId;
  int? isPinned;
  List<String>? noteLinks ;
  List<String>? imageLinks ;
  String type ;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {

  var isListening = false;
  SpeechToText speechToText = SpeechToText();

  TextEditingController headingController = TextEditingController();
  final QuillEditorController quillController = QuillEditorController();
  // ScreenshotController screenshotController = ScreenshotController();
  
  bool isGeneratingPdf = false;
  File? _image;
  List<String> linksList = [ ];
  List<String> imagesList = [ ];

  DBHelper? dbHelper ;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();

    if(widget.type != "new"){
      setNotes();
    }
  }
  
  

  setNotes() async{
    headingController.text = widget.heading! ;

    for(var i in widget.noteLinks!){
      linksList.add( i.toString() );
    }

    for(var i in widget.imageLinks!){
      imagesList.add( i.toString() );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: lightGradient()
      //     ),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async{
          return customPushAndOffAllScreen(context,  const HomeScreen());
        },
        child: SafeArea(
          child: Container(
           child: Column(
            children: [
              //& editor toolbar
              editorToolbar(),
        
              //& text editing area
              Expanded(
                child: SingleChildScrollView(
                  child: notesArea(),
                ),
              ),
            ],
           ),
          ),
        ),
      ),
      floatingActionButton: AvatarGlow(
        endRadius: 46.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: primaryColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async{
            if(!isListening){
              var available = await speechToText.initialize();
              if(available){
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result){
                        setState(() async{
                          await quillController.insertText(result.recognizedWords);
                        });
                      }
                    );
                  });
              }
            }
          },
          onTapUp: (detail){
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 28,
            child: Icon(isListening ? Icons.mic : Icons.mic_none,color: Colors.white,),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  
  editorToolbar() {
    return ToolBar(
        // toolBarColor: primaryColor.withOpacity(.01),
        activeIconColor: Colors.green,
        iconColor: primaryColor,
        verticalDirection: VerticalDirection.down,
        spacing: 10,
        toolBarConfig: const [
          ToolBarStyle.blockQuote,
          ToolBarStyle.codeBlock,
          // ToolBarStyle.clearHistory,
          ToolBarStyle.clean,
          ToolBarStyle.background,
          ToolBarStyle.color,
          ToolBarStyle.italic,
          ToolBarStyle.underline,
          ToolBarStyle.bold,
          ToolBarStyle.listBullet,
          ToolBarStyle.align,
          ToolBarStyle.undo,
          ToolBarStyle.redo,
          ToolBarStyle.size,
          ToolBarStyle.strike,
        ],
        padding: const EdgeInsets.all(8),
        iconSize: 25,
        controller: quillController,
        customButtons: [
          InkWell(
            onTap: () {
              imageDialog();
            }, 
            child: const Icon(Icons.image)
          ),
          InkWell(
            onTap: () async{
              shareDialog();
            }, 
            child: !isGeneratingPdf ? const Icon(Icons.share)  : Container(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(color: primaryColor, )
            )
          ),
          if(widget.type != "new")
            InkWell(
              onTap: () async{
                deleteDialog();
              }, 
              child: const Icon(Icons.delete)
            ),
          Builder(
            builder: (context){
              return InkWell(
                onTap: () async{
                  if(headingController.text.isNotEmpty){
                    if(widget.type != "new"){
                      saveNotes(widget.category!.trim());
                    }else{
                      _showButtomSheet(context);
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Heading cannot be Empty",
                           textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }, 
                child: const Icon(Icons.save)
              );
            },
          ),
        ],
        // direction: Axis.horizontal,
      );
  }
  
  notesArea() {
    return Column(
      children: [
        //& note editing area
        notesEditingArea(), 
                

        //& all links
        allLinks(),

        //& all images
        allImages(),
      ],
    );
  }
  
  notesEditingArea() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        // height: 260 ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(.2),
          border: Border.all(color: Colors.deepPurple)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: TextField(
                  controller: headingController,
                  style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),
                  decoration: const InputDecoration(
                    hintText: "Heading..",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 25,color: Colors.grey)
                  ),
                ),
              ),

              QuillHtmlEditor(
                text: widget.type != "new" ? widget.notes :"Write notes here ✍️...",
                hintText: 'write notes here...',
                controller: quillController,
                isEnabled: true,
                minHeight: 196,
                textStyle: const TextStyle(color: Colors.blue),
                hintTextStyle: const TextStyle(color: Colors.amber),
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 5,bottom: 5,right: 5),
                hintTextPadding: EdgeInsets.zero,
                // onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                // onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                // onEditingComplete: (s) => debugPrint('Editing completed $s'),
                // onEditorResized: (height) =>
                // debugPrint('Editor resized $height'),
                // onSelectionChanged: (sel) =>
                // debugPrint('${sel.index},${sel.length}'),
                // loadingBuilder: (context) {
                //     return const Center(
                //     child: CircularProgressIndicator(
                //     strokeWidth: 0.4,
                //     ));},
              ),
            ],
          ),
        ),
      );
  }
  
  allLinks() {
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              children: [
                Expanded(child: Text("Important links",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.black),)),

                GestureDetector(
                  onTap: (){
                    addLinkDialog();
                  },
                  child: Icon(Icons.add_link_sharp,size: 35,color: Colors.deepPurple,)
                ),
              ],
            ),

            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 30,maxHeight: 100),
              child: Container(
                margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                child: linksList.length > 0
                 ?ListView.builder(
                  shrinkWrap: true,
                  itemCount: linksList.length,
                  itemBuilder: (context, index){
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async{
                                await launchUrl(Uri.parse(linksList[index]));
                              },
                              child: Text(
                                linksList[index] ,
                                style: const TextStyle(color: Colors.deepPurple,overflow: TextOverflow.ellipsis),
                              ),
                            )
                          ),
                          const SizedBox(width: 10,),
                      
                          GestureDetector(
                            onTap: (){
                              linksList.removeAt(index);
                              setState(() {});
                            },
                            child: const Icon(Icons.delete,size: 20,color: Colors.redAccent,)
                          ),
                        ],
                      ),
                    );
                  },
                ) : const Text("Links not added")
              ),
            ),
        ],
      ),
    );
  }
  
  allImages() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
            const Text("Images",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.black),),
            
            imagesList.isNotEmpty ?
            Container(
              margin: const EdgeInsets.only(left: 5,right: 10,top: 10),
              height: 200,
              child: ListView.builder(
                itemCount: imagesList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return Container(
                    width: 145,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Image.file(File(imagesList[index]),fit: BoxFit.cover,)
                    ),
                  );
                }
              ),
            ): Container(margin: const EdgeInsets.symmetric(horizontal: 10),child: const Text("No Images")),
        ],
      ),
    );
  }


  imageDialog(){
    return showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog.adaptive(
          backgroundColor: bluishWhite,
          content: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    getImageFile(ImageSource.gallery);
                  },
                  child: const Icon(Icons.image,size: 40,color: Colors.deepPurple,)
                )
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    getImageFile(ImageSource.camera);
                  },
                  child: const Icon(Icons.camera_alt_outlined, size: 40,color: Colors.deepPurple,)
                )
              ),
            ],
          )
        );
      },
    );
  }

  shareDialog(){
    return showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog.adaptive(
          backgroundColor: bluishWhite,
          content: Container(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                           Navigator.of(context).pop();
                           
                           String heading = headingController.text ?? "" ;
                           String text = await quillController.getPlainText();
                           String links='';
                           for(String link in linksList){
                            links = "${links}\n${link}";
                           }
                          //  Share.share("Headings\n\n${text.toString()}");
                           Share.share("$heading \n\n${text.toString()}\n\nLinks${links}");
                        },
                        child: const Icon(Icons.textsms_outlined,size: 40,color: Colors.deepPurple,)
                      ),
                      const Text("Share Text", style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          generatePdf();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Generating PDF..",
                                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.picture_as_pdf, size: 40,color: Colors.deepPurple,)
                      ),
                      const Text("Share Pdf",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  addLinkDialog(){
    final TextEditingController linkController = TextEditingController();
    return showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog.adaptive(
          backgroundColor: bluishWhite,
          content: TextField(
            controller: linkController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter link"
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: Text('Cancel',style: myTextStyle(),),
            ),
            TextButton(
              onPressed: () {
                if(linkController.text.isNotEmpty){
                  linksList.add(linkController.text.toString().trim());
                  setState(() { });
                }
                Navigator.of(context).pop(true); 
              },
              child: Text('Add',style: myTextStyle(),),
            ),
          ],
        );
      },
    );
  }

  deleteDialog(){
    return showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog.adaptive(
          backgroundColor: bluishWhite,
          content: Text(
            "You want to delete this note ?",
            style: myTitleTextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                for(String path in imagesList){
                  deleteFromFile(path);
                }
                await dbHelper!.delete(widget.noteId!);
                Navigator.of(context).pop(true); // Return true when OK is pressed

                //^ move to home screen
                customPushAndOffAllScreen(context, const HomeScreen());
              },
              child: Text('Yes',style: myTextStyle(),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when Cancel is pressed
              },
              child: Text('Cancel',style: myTextStyle(),),
            ),
          ],
        );
      },
    );
  }
  
  myTextStyle() {
    return const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple
    );
  }

  myTitleTextStyle() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: darkText
    );
  }


  getImageFile(ImageSource source) async{
    final ImagePicker picker = ImagePicker();
    File? newPath; //to compresion use
    XFile? newImage ; 

    try {
        //for compression code
        newImage = await picker.pickImage(source: source);
        if(newImage != null){ 
          final bytes  = await newImage!.readAsBytes();
          final kb = bytes.length /1024;
          final mb = kb/1024;
          if(kDebugMode){
            print("original image size = "+mb.toString());
          }
          final dir = await path_provider.getTemporaryDirectory();
          final targetPath = '${dir.absolute.path}/${DateTime.now()}.jpg';

          //now converting original to compress//
          final result = await FlutterImageCompress.compressAndGetFile(
            newImage!.path,
            targetPath,
            minHeight: 1080, //this can be change by need
            minWidth: 1080,
            quality: 50, //keep this high to get the original quality of image
          );
          
          final data = await result!.readAsBytes();
          final newKb = data.length/1024;
          final newMb = newKb/1024;
          if(kDebugMode){
            print("compressed image size = "+newMb.toString());
          }

          newPath = File(result!.path) ;
          //compression code end

       
          setState(() {
            imagesList.add(newPath!.path);
          });
         
          if (kDebugMode) {
            print("file path----->${_image!.absolute.toString()}");
          }

          Navigator.of(context).pop();
        }
        else{
          if (kDebugMode) {
            print("Image Not Choosen !");
          }
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Something Went Wrong'),
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 1),
          ));
        }
    } catch (e) {
      // Handle any errors that occur while picking the image
      Navigator.of(context).pop();

      if (kDebugMode) {
        print('Error picking image: $e');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: const Text('Something Went Wrong'),
        //   backgroundColor: primaryColor,
        //   duration: const Duration(seconds: 1),
        // ));
      }
    }
  }

  saveNotes(String category) async{
    String? htmlText = await quillController.getText() ;
    String? plain = await quillController.getPlainText() ;
    if(widget.type != "new"){
      //^ update old notes
      dbHelper!.update(
        Note(
          id: widget.noteId,
          isImportant: widget.isPinned ?? 0, 
          category: category.trim(), 
          title: headingController.text.trim() == "" ? " " :headingController.text.trim(), 
          description: htmlText, 
          plainText: plain, 
          createdTime: DateTime.now().toString(),
          images: imagesList,
          links: linksList
        )
      ).then((value) {
        if (kDebugMode) {
          print("Note updated");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notes updated",
                textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            backgroundColor: Colors.green,
          ),
        );

      })
      .onError((error, stackTrace) {
        if (kDebugMode) {
          print("error in adding note..");
          print(error.toString());
        }
      });
    }
    else{
      //^ insert new note
      dbHelper!.insert(
        Note(
          isImportant: 0, 
          category: category.trim(), 
          title: headingController.text.trim() == "" ? " " :headingController.text.trim(), 
          description: htmlText, 
          plainText: plain,
          createdTime: DateTime.now().toString(),
          images: imagesList,
          links: linksList
        )
      ).then((value) {
        if (kDebugMode) {
          print("new note added");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notes Added",
                textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            backgroundColor: Colors.green,
          ),
        );

        //^ move to home page
        customPushAndOffAllScreen(context, const HomeScreen());
      })
      .onError((error, stackTrace) {
        if (kDebugMode) {
          print("error in adding note..");
          print(error.toString());
        }
      });
    }
  }

  // shareImage() async{
  //   await screenshotController.capture(delay: Duration(milliseconds: 100),pixelRatio: 1.0).then((Uint8List? img) async{
  //     if(img!=null){
  //       final directory = (await path_provider.getApplicationDocumentsDirectory()).path;
  //       final filename = "note.png";
  //       final imgPath = await File("${directory}/$filename").create();
  //       await imgPath.writeAsBytes(img);

  //       Share.shareFiles([imgPath.path],text: "Generated by mourya Devs");
  //     }
  //     else{
  //       print("Failed to create image");
  //     }
  //   });
  // }


void generatePdf() async{
  setState(() {
    isGeneratingPdf = true ;
  });

  final pdf = pw.Document();

  final plainText = await quillController.getPlainText();
  // final font = await PdfGoogleFonts.nunitoExtraLight();
  final emoji = await PdfGoogleFonts.notoColorEmoji();

  //^ Load app icon image from assets
  ByteData data = await rootBundle.load('assets/icons/appicon.png');
  List<int> appIconImageData = data.buffer.asUint8List();
  Uint8List uint8ListImageData = Uint8List.fromList(appIconImageData);
  final appIcon = pw.Image(pw.MemoryImage(uint8ListImageData), width: 40, height: 40);
    
  //^ Add widgets to PDF document
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        List<pw.Widget> widgets = [
            pw.Container(
              alignment: pw.Alignment.center,
              width: double.maxFinite,
              // height: 70,
              padding: pw.EdgeInsets.symmetric(vertical: 10),
              color: PdfColor.fromHex("#7F2862"),
              child: pw.Text(
                headingController.text,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 34
                ),
                textAlign: pw.TextAlign.center
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                plainText,
                style: pw.TextStyle(
                  fontFallback: [emoji],
                  color: PdfColors.purple,
                  // color: PdfColor.fromHex("#7F2862"),
                  fontSize: 22
                )
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Align(
              alignment: pw.Alignment.bottomRight,
               child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Notescribe",
                    style: pw.TextStyle(color: PdfColor.fromHex("#7F2862"), fontSize: 20,),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Image(pw.MemoryImage(uint8ListImageData), width: 40, height: 40)
                ]
              ),
            ),

        ];

        if(linksList.isNotEmpty){
          widgets.add(
            pw.Text(
                "Links",
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: pw.TextAlign.left
            ),
          );
        }

        //^ Add links from linksList
        for (var link in linksList) {
          widgets.add(
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              margin: pw.EdgeInsets.symmetric(horizontal: 10,vertical: 1),
              child: pw.Text(
                link,
                style: pw.TextStyle(
                  color: PdfColors.blue,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }

        if(linksList.isNotEmpty){
          widgets.add(
            pw.SizedBox(height: 20),
          );
        }

        //^ Add images from imagesList
        for (var imagePath in imagesList) {
          widgets.add(
            // pw.SizedBox(height: 20), // Add some space between images
            pw.Container(
              margin: pw.EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: pw.Image(
                pw.MemoryImage(File(imagePath).readAsBytesSync()),
                height: 220,
                width: 270,
                fit: pw.BoxFit.fitHeight,
              )
            ),
          );
        }
  
        return widgets;

      },
    ),
  );

  // //^ Save PDF to a file
  // final dir = await path_provider.getTemporaryDirectory();
  // final file = File('${dir.absolute.path}/notescribe_${DateTime.now()}.pdf');
  // await file.writeAsBytes(await pdf.save());

  // //^ Share PDF file
  // if (file.existsSync()) {
  //   Share.shareFiles([file.path], text: 'Sharing PDF');
  // }

  setState(() { isGeneratingPdf = false ;});
  
  //^ using printing to share 
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'notescribe_${DateTime.now()}.pdf');

  //^ system printing option and with preview 
  // await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save());
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
                            onTap: (){
                              saveNotes(notesCategory[index]);
                              Navigator.pop(context);
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


}