import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class TicketView extends StatefulWidget {

  final String user_id;
  final String user_type;
  final String id;
  final String issues;
  final String content;
  final String status;
  final String date;

  const TicketView({Key key, this.id, this.issues, this.content, this.status, this.date, this.user_id, this.user_type}) : super(key: key);

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {

  TextEditingController _comments = TextEditingController();
  // ProgressDialog pr;
  var _myList;

  @override
  void initState() {
    super.initState();
    getData();
  }
  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }
  Future<String> getData() async {
    try {
      // final response = await http.get(Uri.parse(global.baseUrl+"my_tickets?cust_id=67"));
      final response = await http.get(Uri.parse(global.baseUrl + "my_ticketsmsg?ticket_id="+widget.id));

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

    // pr = new ProgressDialog(context);
    // pr.style(
    //   progress: 50.0,
    //   message: "Loading...",
    //   progressWidget: Container(
    //       padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
    //   maxProgress: 100.0,
    //   progressTextStyle: TextStyle(
    //     color: Colors.black45,
    //     fontSize: 13.0,
    //     fontFamily: 'SF UI Display Regular',
    //   ),
    //   messageTextStyle: TextStyle(
    //     color: Colors.black45,
    //     fontSize: 19.0,
    //     fontFamily: 'SF UI Display Regular',
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("View Complaints"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.green[50],
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                                text: "Complaint ID: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: widget.id),
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
                              TextSpan(text: widget.status.toUpperCase()),
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
                                text: 'Issue Type    : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: widget.issues.toString()),
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
                            text: 'Raised On     : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${DateFormat('hh:mm a').add_yMMMd().format(DateTime.parse(widget.date))}'),
                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    Text("Description   :",style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8,),

                    Text(widget.content),

                    SizedBox(height: 15,),
                    Text("Your Comments :",style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Container(
                      // height: 5,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          maxLines: 5,
                          controller: _comments,
                          readOnly: widget.status == "closed" ? true : false,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey[400],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey[500],
                                )),
                            // hintText: 'Description',
                            labelText: 'Comments',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black38,
                            ),
                          ),
                        )),

                    Visibility(
                        visible: widget.status == "closed" ? false : true,
                        child: SizedBox(height: 10)),
                    Visibility(
                      visible: widget.status == "closed" ? false : true,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                        child: ElevatedButton(
                          child: Text('SUBMIT'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              textStyle: TextStyle(
                                  color: Colors.white)),
                          onPressed: () {
                            if(_comments.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Please enter comment!" , toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
                            }
                            else {
                              submitCheck();
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 15,),
                    Text("Complaint History :",style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),



                  ],
                ),
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
                child: Text("History Not Found!"),
              ),
            )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _myList.length,
                    itemBuilder: (context, index) =>
                        Card(
                          color: _myList[index]["msgfrom"] == "admin" ? Colors.red[100] :  Colors.green[100],
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Time & Date: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: '${DateFormat('hh:mm a').add_yMMMd().format(DateTime.parse(_myList[index]["created_at"]))}'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Status: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: _myList[index]["status"].toString()),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Updated By: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: _myList[index]["msgfrom"].toString().toUpperCase()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15,),
                                Text("Description :",style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5,),

                                Text(_myList[index]["message"] ?? ""),

                              ],
                            ),
                          ),
                        ))
          ],
        ),
      ),
    );
  }
  void hideLoader() {
    Navigator.pop(context);
  }
  Future submitCheck() async {
    showOnlyLoaderDialog();
    Uri uri = Uri.parse(global.baseUrl+"my_ticketreplymsg");

    Map<String, dynamic> map = <String, dynamic> {
      'user_id': widget.user_id,
      'ticketid': widget.id,
      'message': _comments.text.toString(),
      'user_type': "user",
    };

    http.Response response = await http.post(uri,
      body: map,
    );

    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : "+response.body);

    var jsonData = jsonDecode(response.body);

    String status = jsonData['status'].toString();
    String msg = jsonData['data'];

    if (status == "200") {
      hideLoader();
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
      Navigator.pop(context);
    } else {
      hideLoader();
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    }
  }

}
