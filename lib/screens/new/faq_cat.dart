import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomeat/screens/new/CatModel.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'faq.dart';

class FAQ_CAT extends StatefulWidget {
  const FAQ_CAT({Key key}) : super(key: key);

  @override
  State<FAQ_CAT> createState() => _FAQState();
}

class _FAQState extends State<FAQ_CAT> {

  List _myList;
  YoutubePlayerController _controller;
  var _cat;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<String> getData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"faqcat"));

      print("aaaaaaaaaaaaaa : "+global.baseUrl+"faqlist");

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Help & Support (FAQs)"),),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _myList == null ? Center(child: CircularProgressIndicator()) : _myList.length == 0 ? Center(child: Text("Data not found!")) : ListView.builder(
            itemCount: _myList.length,
            itemBuilder: (context, i) {

              return Card(
                margin: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FAQ(cat_id: _myList[i]["id"].toString()),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_myList[i]["name"]),
                        Icon(Icons.arrow_forward_outlined)
                      ],
                    ),
                  ),
                ),
              );

            },
          ),
        ),
    );
  }

  void showSnackBar({String snackBarMessage, Key key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryTextTheme.headline5.color,
      key: key,
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
  }

}
