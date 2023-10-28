import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newtest/artCollection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import 'api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var selectedSize;

  List<String> sizeList = ['Small','Medium','Large'];

  List<String> sizeValueList= ['256x256','512x512','1024x1024'];

  final inputController = TextEditingController();

  bool isLoding = false;

  String imagevalue = '';
  var imageList ;



  Future<void> downloadFile(String url, String savePath) async {
    print("working or not ");
    try {
      print("yes  working ${url}");
      Dio dio = Dio();

      var response = await dio.download(url, savePath);
      print("response here ${response.statusMessage} and ${savePath}");
        if(response.statusMessage == "Ok"){
          print("response ${response} and ${savePath}");
          setState(() {

          });
          const snackBar = SnackBar(
            content: Text('Image download successfully'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    } catch (error) {
      print('Error downloading file: $error');
    }
  }

  downloadImage(url)async{

    String fileUrl = '${url}';
    String fileName = '${inputController.text}.png';

    Directory? directory = await getDownloadsDirectory();
    String savePath = '${directory!.path}/$fileName';

    await downloadFile(fileUrl, savePath);

    // var status = await Permission.storage.request();
    // print("checking permission ${status}");
    // if(status == PermissionStatus.granted){
    //   FileDownloader.downloadFile(url: url,
    //       name: "fileName.png",
    //       onProgress: (String? fileName,double process){
    //         print("File ${fileName} and process ${process}");
    //       },
    //       onDownloadCompleted: (String path){
    //         print("file downloaded successfully ${path}");
    //       },
    //       onDownloadError: (String error){
    //         print("checking error ${error}");
    //       }
    //   );
    // }
    // else{
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.camera,
    //     Permission.storage,
    //   ].request();
    //
    //    Permission.storage.request();
    //
    //   print("Permission is not granted ${statuses}");
    // }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:   Padding(
        padding:  EdgeInsets.only(bottom: 10,left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(onPressed: (){

              downloadImage(imagevalue.toString());
            },
              color: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)
              ),
              height: 45,
              minWidth: MediaQuery.of(context).size.width/1.5,
              child: Text("Download",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),),),
            // SizedBox(width: 10,),
            // MaterialButton(onPressed: ()async{
            //
            // },
            //   color: Colors.purple,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(9)
            //   ),
            //   height: 45,
            //
            //   child: Row(
            //     children: [
            //       Icon(Icons.share,color: Colors.white,),
            //       SizedBox(width: 5,),
            //       Text("Share",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),),
            //     ],
            //   ),),

          ],
        ),
      ) ,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ai Image Generator"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ArtCollection()));
            },
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.only(right: 10,top: 8,bottom: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text("My Arts",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),)),
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: inputController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter image description",
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                inputController.clear();
                                imageList = [];
                              });
                            },
                            child: Icon(Icons.clear,color: Colors.black,)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.transparent)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.transparent)
                        ),
                        fillColor: Colors.white,
                        filled: true
                      ),
                    ),
                  ),
                    SizedBox(width: 10,),
                  Container(
                    height: 45,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Icon(Icons.expand_more,color: Colors.black,),
                        value: selectedSize,
                        hint: Text("Select Size",style: TextStyle(color: Colors.black),),
                        items: List.generate(sizeList.length, (index) => DropdownMenuItem(child:Text(sizeList[index],style:TextStyle(color: Colors.black),),value: sizeValueList[index],)),
                        onChanged: (v){
                          setState(() {
                            selectedSize = v.toString();
                          });
                        },
                      ),
                    )
                  )
                ],
              ),
              SizedBox(height: 25,),

              MaterialButton(onPressed: ()async{
                setState(() {
                  imageList = [];
                });
                if(selectedSize == null || selectedSize == "" || inputController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter description and select size")));
                }
                else{
                  setState(() {
                    isLoding = true;
                  });
                 // imagevalue = await Api.generateImage(inputController.text, selectedSize.toString());
                   imageList = await Api.generateImage(inputController.text, selectedSize.toString());

                  print("new image list here ${imageList['data']}");
                  setState(() {
                    isLoding = false;
                  });
                }
              },child: Text("Generate",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)
                ),
                height: 45,
                minWidth: MediaQuery.of(context).size.width/1.5,
              ),
              SizedBox(height: 50,),
              isLoding == true ? Center(child:CircularProgressIndicator(color: Colors.white,)) :  imageList == null ? Text("No image to show",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),) :
              Container(
                child: GridView.builder(
                  shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
                    itemCount: imageList['data'].length,
                    itemBuilder: (c,i){
                      print("checking result here ${imageList['data'][i]['url']}");
                      return InkWell(
                          onTap: (){
                            setState(() {
                              imagevalue = imageList['data'][i]['url'].toString();
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: imagevalue == imageList['data'][i]['url'].toString() ? Colors.white : Colors.transparent)
                              ),
                              child:ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network("${imageList['data'][i]['url']}",fit: BoxFit.cover,),)));
                    }),
              ),
               // SizedBox(height: 25,),

            ], 
          ),
        ),
      )
    );
  }
}
// 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