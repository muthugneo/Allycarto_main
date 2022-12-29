import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:http/http.dart' as http;

import '../paymentGatewayScreen.dart';

class MyScanner extends StatefulWidget {
  const MyScanner({Key key}) : super(key: key);

  @override
  State<MyScanner> createState() => _MyScannerState();
}

class _MyScannerState extends State<MyScanner> {

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<String> splitList;
  TextEditingController _arxController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.resumeCamera();
    }
    controller.resumeCamera();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: result != null ? AppBar(title: Text("Send ARX"),) : null,
      body: Column(
        children: <Widget>[
          result == null ? Expanded(flex: 4, child: _buildQrView(context)) : SizedBox.shrink(),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (result != null)
                  Column(
                    children: [
                      Image.asset("assets/logo.jpg",height: 155,),
                      SizedBox(height: 25,),
                      Text(splitList[0].toString(),
                          style: TextStyle(fontSize: 20,color: Colors.red)),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
                        child: Card(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextField(
                                controller: _arxController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(hintText: "Enter ARX Value", hintStyle: TextStyle(color: Colors.black54)),
                              ),
                            )
                        ),
                      ),
                    ],
                  )
                else
                  const Text('Scan a code'),
                result == null ? Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.resumeCamera();
                    },
                    child: const Text('Scan',
                        style: TextStyle(fontSize: 20)),
                  ),
                ) : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.green,
                  ),
                  margin: EdgeInsets.only(top: 25, left: 70, right: 70),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                      onPressed: () async {
                        // Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //           builder: (context) => PaymentGatewayScreen(
                        //               screenId: 3,
                        //               totalAmount:
                        //                   int.parse(_cAmount.text.trim()),
                        //               a: widget.analytics,
                        //               o: widget.observer),
                        //         ),
                        //       );
                        // global.currentUser.wallet
                        if(_arxController.text == "") {
                          showSnackBar(key: _scaffoldKey, snackBarMessage: 'Enter ARX Value!');
                        } else {
                          int enterAmmount=int.parse(_arxController.text);
                          
                          if(enterAmmount > global.currentUser.wallet){
int pendingAmmount = enterAmmount- global.currentUser.wallet;
Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PaymentGatewayScreen(
                                                screenId: 3,
                                                totalAmount: pendingAmmount,
                                                a: analytics,
                                                o: observer
                                                ),
                                          ),
                                        );
                          }else
                          showAlertDialog(context);
                        }
                      },
                      child: Text('Submit',
                          style: TextStyle(fontSize: 20, color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.pauseCamera();
                //         },
                //         child: const Text('pause',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.resumeCamera();
                //         },
                //         child: const Text('resume',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        splitList = result.code.toString().split("|");
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please Allow Camera Permission'),duration: Duration(seconds: 2),),
      // );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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

  void hideLoader() {
    Navigator.pop(context);
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
        sendData();
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
        "shop_id": splitList[1].toString(),
        "arx": _arxController.text.toString(),
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
