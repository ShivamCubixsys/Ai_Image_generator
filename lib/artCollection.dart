import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ArtCollection extends StatefulWidget {
  const ArtCollection({super.key});

  @override
  State<ArtCollection> createState() => _ArtCollectionState();
}

class _ArtCollectionState extends State<ArtCollection> {

  List imgList = [];

  getImages()async{
  final diectory =  (await getDownloadsDirectory())?.path;
  setState(() {
    imgList =  io.Directory("${diectory}/").listSync();
  });
  print("chekcing list here ${imgList}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 400),(){
      return getImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: Text("My Arts"),
      ),
      body:imgList.isEmpty ? SizedBox() : GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
          itemCount: imgList.length,
          itemBuilder: (c,i){
          return Container(child:Image.file(imgList[i]));
          }),
    );
  }
}
