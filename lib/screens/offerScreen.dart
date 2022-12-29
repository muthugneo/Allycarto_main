import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/couponModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'new/shop_products.dart';
import 'new/vendor_details_screen.dart';

class OfferListScreen extends BaseRoute {
  OfferListScreen({a, o}) : super(a: a, o: o, r: 'OfferListScreen');
  @override
  _OfferListScreenState createState() => new _OfferListScreenState();
}

class _OfferListScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDataLoaded = false;
  var _myList;

  _OfferListScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: SizedBox(),
          title: Text("${AppLocalizations.of(context).lbl_offer}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _myList == null ? Center(child: CircularProgressIndicator()) : _myList.length == 0 ? Center(child: Text("No data found!"))
              : ListView.builder(
              itemCount: _myList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if(_myList[index]["delivery_type"] == "online") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShopProductListScreen(1, _myList[index]["shop_name"], _myList[index]["vendor_id"].toString(), subcategoryId: _myList[index]["vendor_id"], a: widget.analytics, o: widget.observer),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VendorDetails(_myList[index]["vendor_id"].toString(), _myList[index]["shop_name"], _myList[index]["admin_image"], _myList[index]["pincode"].toString(),
                                        _myList[index]["latitude"].toString(), _myList[index]["longitude"].toString(), _myList[index]["shop_description"] ?? "", a: widget.analytics, o: widget.observer),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 140,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: global.appInfo.imageUrl + _myList[index]["image"],
                                imageBuilder: (context, imageProvider) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: AssetImage('${global.defaultImage}'), fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              '${_myList[index]["name"]}',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12,)
                  ],
                );
              })
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<String> getListData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"offerbanner"));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }
}
