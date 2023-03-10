import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;

class WebViewScreen extends StatefulWidget {
  final String custid;
  final String mlmid;
  final bool report;
  final String url;
  final String name;
  WebViewScreen(
      {@required this.custid,
      @required this.mlmid,
      @required this.report,
      this.url,
      this.name});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController controllerGlobal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return WillPopScope(
      onWillPop: _exitApp,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0.0,
            title: Text(
              widget.report ? widget.name : "MLM Tree",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.report
                          ? "${global.baseUrl}${widget.url}"
                          : global.baseUrl +
                              "mlmtreec/" +
                              widget.mlmid +
                              "/" +
                              widget.custid,
                      gestureNavigationEnabled: true,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.future
                            .then((value) => controllerGlobal = value);
                        _controller.complete(webViewController);
                      },
                      onPageStarted: (String url) {
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      onPageFinished: (String url) {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    if (controllerGlobal != null) {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(true);
    }
  }
}
