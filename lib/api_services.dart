import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'api_key.dart';

class Api{
  static final url = Uri.parse("https://api.openai.com/v1/images/generations");

  static final headers = {
    "Content-Type":"application/json",
    "Authorization":"Bearer $apiKey",
  };
  static  generateImage(String text,String size)async{
    Response res =  await http.post(url,headers: headers,body:jsonEncode(
    {
      "prompt":"${text}",
      "n":5,
      "size":"${size}"
    }
  ));
  if(res.statusCode ==200){
    var data = jsonDecode(res.body.toString());
    print("checking response here ${data}");
   return data;
  }
  else{
    print("failed to fetch image");
  }

  }
}