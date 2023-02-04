import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/screens/new/shop_products.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../paymentGatewayScreen.dart';

class VendorDetails extends BaseRoute {
  final String shopId;
  final String shopName;
  final String shopImage;
  final String shopAddress;
  final String shopLat;
  final String shopLon;
  final String shopDesc;

  VendorDetails(this.shopId, this.shopName, this.shopImage, this.shopAddress, this.shopLat, this.shopLon, this.shopDesc, {a, o}) : super(a: a, o: o, r: 'CategoryListScreen');

  @override
  _VendorDetailsScreenState createState() => new _VendorDetailsScreenState(this.shopId, this.shopName, this.shopImage, this.shopAddress, this.shopLat, this.shopLon, this.shopDesc);
}

class _VendorDetailsScreenState extends BaseRouteState {

   String shopId;
   String shopName;
   String shopImage;
   String shopAddress;
   String shopLat;
   String shopLon;
   String shopDesc;
   TextEditingController _arxController = TextEditingController();
   TextEditingController _arxxController = TextEditingController();
   GlobalKey<ScaffoldState> _scaffoldKey;

   _VendorDetailsScreenState(this.shopId, this.shopName,this.shopImage, this.shopAddress, this.shopLat, this.shopLon, this.shopDesc) : super();

   GoogleMapController mapController;
   LatLng shopLatLng;
   void _onMapCreated(GoogleMapController controller) {
     mapController = controller;
   }

   @override
   void initState() {

     setState(() {
       shopLatLng = LatLng(
         double.parse(shopLat),
         double.parse(shopLon),
       );
     });

     super.initState();
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Shop Details"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: global.appInfo.imageUrl + shopImage,
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
                      height: 150,
                      width: 250,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          shopName,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 10,
                      color: Colors.grey[200],
                    ),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address ",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                shopAddress.isNotEmpty?shopAddress:"No Address",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .copyWith(fontSize: 13),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )),
                       Container(
                      height: 10,
                      color: Colors.grey[200],
                    ),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description ",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                               shopDesc.isNotEmpty? shopDesc:"No Description",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .copyWith(fontSize: 13),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )),
                    
                      
                  ],
                ),
              ),
             
              // Visibility(
              //   visible: shopDesc == "" ? false : true,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 12.0, top: 10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Column(
              //           children: [
              //             Text(
              //               "Description :",
              //               style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
              //               maxLines: 2,
              //             ),
              //             Text(
              //               shopDesc,
              //               style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
              //               maxLines: 2,
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                color: Colors.grey[200],
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red,
                    ),
                    // margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                    height: 40,
                    width: 150,
                    child: TextButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShopProductListScreen(1,shopName,shopId, subcategoryId: int.parse(shopId), a: widget.analytics, o: widget.observer),
                            ),
                          );
                        },
                        child: Text('Shop Products',
                            style: TextStyle(fontSize: 14, color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit_note_outlined),
                    // Image.asset("assets/edit.png", height: 30, width: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        "Needed Products List",
                        style:  Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _arxController,
                        maxLines: 6,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration.collapsed(hintText: "Please enter your needed products list with Quantity - One by One", hintStyle: TextStyle(color: Colors.black54)),
                      ),
                    )
                ),
              ),
              SizedBox(height: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.green,
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    width: 150,
                    child: TextButton(
                        onPressed: () async {
                          if(_arxController.text == "") {
                            showSnackBar(key: _scaffoldKey, snackBarMessage: 'Enter your needed products list with Quantity - One by One!');
                          } else {
                            sendData();
                          }
                        },
                        child: Text('Send the list to Shop',
                            style: TextStyle(fontSize: 14, color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
SizedBox(
  height: 10,
),
               Container(
                height: 10,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/token.png", height: 30, width: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        "Pay via my ARX Wallet",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _arxxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration.collapsed(hintText: "Please enter your Order Amount", hintStyle: TextStyle(color: Colors.black54)),
                      ),
                    )
                ),
              ),
              SizedBox(height: 1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.green,
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    width: 150,
                    child: TextButton(
                        onPressed: () async {
                          if(_arxxController.text == "") {
                            showSnackBar(key: _scaffoldKey, snackBarMessage: 'Enter your Order Amount!');
                          } else {
                            int enterAmmount = int.parse(_arxxController.text);
                            if (enterAmmount > global.currentUser.wallet) {
                              int pendingAmmount =
                                  enterAmmount - global.currentUser.wallet;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PaymentGatewayScreen(
                                      screenId: 3,
                                      totalAmount: pendingAmmount,
                                      a: widget.analytics,
                                      o: widget.observer),
                                ),
                              );
                            } else
                            showAlertDialog(context);
                          }
                        },
                        child: Text('Pay Now',
                            style: TextStyle(fontSize: 14, color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
             SizedBox(
                height: 10,
              ),
              Container(
                height: 10,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 22, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: shopLatLng,
                      zoom: 13.0,
                    ),
                    markers: [
                      Marker(
                        markerId: MarkerId(shopName),
                        position: LatLng(double.parse(shopLat), double.parse(shopLon)),
                        infoWindow: InfoWindow(
                          title: shopName,
                          snippet: shopAddress,
                        ),
                      )
                    ].toSet(),
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

   showAlertDialog(BuildContext context) {

     // set up the buttons
     Widget cancelButton = TextButton(
       child: Text("Cancel", style: TextStyle(color: Colors.grey)),
       onPressed:  () {},
     );
     Widget continueButton = TextButton(
       child: Text("Continue", style: TextStyle(color: Colors.green)),
       onPressed:  () {
         Navigator.pop(context);
         sendData2();
       },
     );

     // set up the AlertDialog
     AlertDialog alert = AlertDialog(
       title: Text("Confirm ARX Payment", style: TextStyle(color: Colors.red),),
       content: Text("Are you sure want to continue this ARX payment?"),
       actions: [
         cancelButton,
         continueButton,
       ],
     );

     // show the dialog
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
   }

   Future<String> sendData() async {
     try {
       showOnlyLoaderDialog();
       final data = {
         "user_id" : global.currentUser.id.toString(),
         "shop_id": shopId,
         "desc": _arxController.text.toString(),
       };
       final headers = {
         'content-type': 'application/json',// 'key=YOUR_SERVER_KEY'
       };
       final response = await http.post(Uri.parse(global.baseUrl+"offlineorder"),
           body: json.encode(data),
           headers: headers);

       var dataConvertedToJSON = json.decode(response.body);

       if(dataConvertedToJSON["status"].toString() == "1")
       {
         hideLoader();
         showSnackBar(key: _scaffoldKey, snackBarMessage: dataConvertedToJSON["message"]);
         Navigator.pop(context);
       } else {
         showSnackBar(key: _scaffoldKey, snackBarMessage: dataConvertedToJSON["message"]);
       }
       return "Success";
     }  catch (e) {
       throw e;
     }
   }

   Future<String> sendData2() async {
     try {
       showOnlyLoaderDialog();
       final data = {
         "user_id" : global.currentUser.id.toString(),
         "shop_id": shopId,
         "arx": _arxxController.text.toString(),
       };
       final headers = {
         'content-type': 'application/json',// 'key=YOUR_SERVER_KEY'
       };
       final response = await http.post(Uri.parse(global.baseUrl+"offline_send_arx"),
           body: json.encode(data),
           headers: headers);

       var dataConvertedToJSON = json.decode(response.body);

       if(dataConvertedToJSON["status"].toString() == "1")
       {
         hideLoader();
         showSnackBar(key: _scaffoldKey, snackBarMessage: dataConvertedToJSON["message"]);
         Navigator.pop(context);
       } else {
         showSnackBar(key: _scaffoldKey, snackBarMessage: dataConvertedToJSON["message"]);
       }
       return "Success";
     }  catch (e) {
       throw e;
     }
   }

}
