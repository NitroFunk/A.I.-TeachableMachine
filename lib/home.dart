import 'dart:io';
import 'package:flutter/material.dart' show Alignment, BorderRadius, BoxDecoration, BuildContext, Center, Color, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, FontWeight, GestureDetector, Image, MediaQuery, Scaffold, SizedBox, State, StatefulWidget, Text, TextStyle, Widget;
import 'package:tflite/tflite.dart' show Tflite;
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  final picker = ImagePicker();
  File _image;
  List _output;
  @override
  void initState()
  {
    super.initState();
    loadModel().then((value){
      setState(() {
      });
    });
  }
  classifyImage(File image) async
  {
    var output = await Tflite.runModelOnImage(path: image.path ,  numResults: 2, threshold: 0.5 , imageMean: 127.5 , imageStd: 127.5 );
    setState(() {
      _output = output;
      loading = false;

    });
  }
  loadModel() async
  {
    await Tflite.loadModel(model: 'assets/model_unquant.tflite' , labels: 'assets/labels.txt');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  pickImage() async
  {
    var image = await picker.getImage(source: ImageSource.camera);
    if(image == null) return null;


    setState(() {
      _image = File(image.path);
    });
   classifyImage(_image);
  }

  pickGalleryImage() async
  {
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null) return null;


    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF101010),
    body: Container(padding: EdgeInsets.symmetric(horizontal: 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 80),
      Text('TeachableMachine.com CNN' , style: TextStyle(color: Color(0xFFEEDA28),fontSize: 18),
      ),
      SizedBox(height: 6),
      Text('Detect Dogs & Cats' , style: TextStyle(color: Color(0xFFE99600), fontWeight: FontWeight.w500 , fontSize: 28),
      ),
      SizedBox(height: 40),
      Center(child: loading ? Container(
        width: 275,
        child: Column(children: <Widget>[
        Image.asset('assets/cat.png'
        ),
        SizedBox(height: 50
        ),
        ],
        ),
      ):Container(
        child: Column(children: <Widget>[
         Container(height: 250, child: Image.file(_image),
         ),
          SizedBox(height: 20),
          _output!= null ? Text('${_output[0]['label']}' ,style: TextStyle(color : Colors.white , fontSize: 20,), ): Container() ,
        SizedBox(height: 10),
        ],),
      ),
      ),
      Container(width: MediaQuery.of(context).size.width,
      child: Column(children: <Widget>[
        GestureDetector(onTap: pickGalleryImage,
        child: Container(width: MediaQuery.of(context).size.width -260, alignment: Alignment.center,padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 17),
        decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.circular(6)
        ),
          child: Text('Take a photo', style: TextStyle(color: Colors.black),),
        ),
        ),
        SizedBox(height: 10
        ),
        GestureDetector(onTap: pickImage,
          child: Container(width: MediaQuery.of(context).size.width -260, alignment: Alignment.center,padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 17),
            decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.circular(6)
            ),
            child: Text('Camera Roll', style: TextStyle(color: Colors.black),),
          ),
        )
      ],),)
    ],
    ),
    ),
    );
  }
}
