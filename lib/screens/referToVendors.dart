import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class ReferToVendors extends BaseRoute {
  ReferToVendors({a, o}) : super(a: a, o: o, r: 'CategoryListScreen');

  @override
  _ReferToVendorsState createState() => _ReferToVendorsState();
}

class _ReferToVendorsState extends BaseRouteState {
  _ReferToVendorsState() : super();
  GlobalKey<ScaffoldState> _scaffoldKey;
  List vendorList;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await _getData();
  }

  _getData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (true) {
          setState(() {});
          // if (_categoryList.isEmpty) {
          //   page = 1;
          // } else {
          //   page++;
          // }
          // ${global.currentUser.referralCode}
          final response = await http.get(
            Uri.parse(global.baseUrl + "vendorapilistbyreferalcode/ACPL00003"),
          );

          setState(() {
            var dataConvertedToJSON = json.decode(response.body);
            vendorList = dataConvertedToJSON['data'] ?? [];
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - categoryListScreen.dart - _init():" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Refer to Vendor"),
        ),
        body: vendorList == null
            ? Wrap(
                spacing: 0,
                runSpacing: 10,
                children: catgoryShimmer(),
              )
            : vendorList.length == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Text("No Recent Activity"),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                        itemCount: vendorList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          var data = vendorList[index]["vuers"];
                          String image = data["admin_image"];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Card(
                              color: Color.fromARGB(255, 231, 231, 231),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                      borderRadius: BorderRadius.circular(55),
                                      image: DecorationImage(
                                        image: image != null && image != ''
                                            ? NetworkImage(
                                                global.appInfo.imageUrl + image)
                                            : AssetImage(
                                                '${global.defaultImage}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${data["name"] ?? ""}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${vendorList[index]["store_status"]}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: vendorList[index]
                                                          ["store_status"] ==
                                                      "open"
                                                  ? Colors.green
                                                  : Colors.red),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ));
  }
}
