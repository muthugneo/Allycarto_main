import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ticket_view.dart';

class MyTicketsPage extends StatefulWidget {
  final String userType;
  const MyTicketsPage({Key key, this.userType}) : super(key: key);

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {

  List _myList, _myAllList;
  var myidd;
  int selectSts = 1;

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myidd = prefs.getString("myidd");
    });
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getData() async {
    try {
      // final response = await http.get(Uri.parse(global.baseUrl+"my_tickets?cust_id=67"));
      final response = await http.get(Uri.parse(global.baseUrl+"my_tickets?cust_id="+global.currentUser.id.toString()));


      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myAllList = dataConvertedToJSON['data'] ?? [];
        _myList = _myAllList
            .where((element) => element["status"] == "open")
            .toList();

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Complaints" ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectSts = 1;
                      _myList = _myAllList
                          .where((element) => element["status"] == "open")
                          .toList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        border: Border.all(
                          color: Colors.yellow[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text("   Open   "),
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      selectSts = 2;
                      _myList = _myAllList
                          .where((element) => element["status"] == "in-progress")
                          .toList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                        border: Border.all(
                          color: Colors.blue[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text("  In-Progress  "),
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      selectSts = 3;
                      _myList = _myAllList
                          .where((element) => element["status"] == "closed")
                          .toList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.green[300],
                        border: Border.all(
                          color: Colors.green[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text("  Closed  "),
                  ),
                ),
              ],
            ),
          ),

          _myList == null
              ? Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          )
              : _myList.length == 0
              ? Center(
            child: Container(
              child: Text("My Complaints Not Found!"),
            ),
          )
              : Expanded(
                child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 5,
            ),
            padding: EdgeInsets.only(top: 6),
            child: ListView.builder(
                  itemCount: _myList.length,
                  itemBuilder: (context, index) =>
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TicketView(id: _myList[index]["id"].toString(),
                                issues: _myList[index]["issues"].toString(),
                                  user_id: myidd,
                                user_type: widget.userType,
                              content: _myList[index]["content"].toString(),status: _myList[index]["status"].toString(),date: _myList[index]["created_at"].toString(),),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.green[50],
                    margin: EdgeInsets.all(5),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Ticket ID     : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: _myList[index]["id"].toString()),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Status :  ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: _myList[index]["status"].toString().toUpperCase()),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Issue Type  : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: _myList[index]["issues"].toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Raised On  : ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${DateFormat('hh:mm a').add_yMMMd().format(DateTime.parse(_myList[index]["created_at"]))}'),
                                ],
                              ),
                            ),

                            SizedBox(height: 15,),
                            Text("Description :",style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5,),

                            Text(_myList[index]["content"]),

                          ],
                        ),
                    ),
                  ),
                      )),
          ),
              ),
        ],
      ),
    );
  }
}
