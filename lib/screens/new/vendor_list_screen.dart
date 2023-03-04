import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/categoryFilterModel.dart';
import 'package:gomeat/models/categoryModel.dart';
import 'package:gomeat/screens/categoryFilterScreen.dart';
import 'package:gomeat/screens/new/shop_products.dart';
import 'package:gomeat/screens/new/vendor_details_screen.dart';
import 'package:gomeat/screens/subCategoryListScreen.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VendorListScreen extends BaseRoute {
  final bool online;
  VendorListScreen(this.online, {a, o})
      : super(a: a, o: o, r: 'CategoryListScreen');
  @override
  _CategoryListScreenState createState() =>
      new _CategoryListScreenState(online);
}

class _CategoryListScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  bool online;
  _CategoryListScreenState(this.online) : super();

  List _shopList;
  bool searcher = false;
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    super.initState();
    getShopData();
  }

  Future<String> getShopData() async {
    try {
      var myPincode = global.sp.getString('myPincode');
      dynamic data;
      if (online) {
        data = {
          "pincode": myPincode,
          "search": search.text,
        };
      } else {
        data = {
          "pincode": myPincode,
          "search": search.text,
        };
      }
      final headers = {
        'content-type': 'application/json', // 'key=YOUR_SERVER_KEY'
      };
      final response = await http.post(
          Uri.parse(
              global.baseUrl + (online ? "online_vendor" : "pincode_vendor")),
          body: json.encode(data),
          headers: headers);

      var dataConvertedToJSON = json.decode(response.body);

      if (dataConvertedToJSON["status"] == 200) {
        setState(() {
          _shopList = dataConvertedToJSON['data'] ?? [];
        });
      }
      return "Success";
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text("${online ? 'Online' : 'Local'} Shops"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  searcher = !searcher;
                });
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: _shopList == null
          ? Center(child: CircularProgressIndicator())
          : _shopList.length == 0
              ? Center(child: Text("No data found!"))
              : Column(
                  children: [
                    if (searcher)
                      Focus(
                        onFocusChange: (bool focus) {
                          if (!focus) {
                            getShopData();
                          }
                        },
                        child: TextFormField(
                          controller: search,
                          decoration: InputDecoration(hintText: "Search shops"),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: _shopList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      (MediaQuery.of(context).size.width / 3) /
                                          126.0,
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: new Card(
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ShopProductListScreen(1, _shopList[i]["name"], _shopList[i]["id"].toString(), subcategoryId: _shopList[i]["id"], a: widget.analytics, o: widget.observer),
                                    //   ),
                                    // );
                                    if (_shopList[i]["status"] == "open") {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VendorDetails(
                                              _shopList[i]["id"].toString(),
                                              _shopList[i]["name"],
                                              _shopList[i]["image"],
                                              _shopList[i]["address"],
                                              _shopList[i]["latitude"]
                                                  .toString(),
                                              _shopList[i]["longitude"]
                                                  .toString(),
                                              _shopList[i]["description"] ?? "",
                                              a: widget.analytics,
                                              o: widget.observer),
                                        ),
                                      );
                                    } else {
                                      showSnackBar(
                                          key: _scaffoldKey,
                                          snackBarMessage:
                                              'This shop currently closed.');
                                    }
                                  },
                                  child: Container(
                                    foregroundDecoration:
                                        _shopList[i]["status"] == "open"
                                            ? BoxDecoration()
                                            : BoxDecoration(
                                                color: Colors.grey,
                                                backgroundBlendMode:
                                                    BlendMode.saturation,
                                              ),
                                    height: 172,
                                    margin: EdgeInsets.only(top: 40, left: 10),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          height: 172,
                                          width: 140,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardTheme
                                                  .color,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 78, left: 10, right: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${_shopList[i]["name"]}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    maxLines: 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${_shopList[i]["status"]}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: _shopList[i][
                                                                        "status"] ==
                                                                    "open"
                                                                ? Colors.green
                                                                : Colors.red),
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -30,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Container(
                                              foregroundDecoration: _shopList[i]
                                                          ["status"] ==
                                                      "open"
                                                  ? BoxDecoration()
                                                  : BoxDecoration(
                                                      color: Colors.grey,
                                                      backgroundBlendMode:
                                                          BlendMode.saturation,
                                                    ),
                                              alignment: Alignment.center,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    global.appInfo.imageUrl +
                                                        _shopList[i]["image"],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            '${global.defaultImage}'),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              height: 100,
                                              width: 130,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
