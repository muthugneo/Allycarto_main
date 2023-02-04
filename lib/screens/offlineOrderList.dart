import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/orderModel.dart';
import 'package:gomeat/screens/orderDetailScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'homeScreen.dart';
import 'locaOrderDetails.dart';

class OfflineOrderListScreen extends BaseRoute {
  OfflineOrderListScreen({a, o})
      : super(a: a, o: o, r: 'OfflineOrderListScreen');
  @override
  _OrderListScreenState createState() => new _OrderListScreenState();
}

class _OrderListScreenState extends BaseRouteState {
  _OrderListScreenState() : super();
  bool _isDataLoaded = false;

  List<Order> _allOrderList = [];
  List<Order> _onGoingOrderList = [];
  List<Order> _completedOrdeList = [];

  bool _isAllOrderPending = true;
  bool _isOngoingOrderPending = true;
  bool _isCompletedOrderPending = true;

  bool _isAllOrderMoreDataLoaded = false;
  bool _isOngoingOrderMoreDataLoaded = false;
  bool _isCompletedOrderMoreDataLoaded = false;

  int _allOrderPage = 1;
  int _onGoingOrderPage = 1;
  int _completedOrderPage = 1;
  TextEditingController search = TextEditingController();
  ScrollController _allOrderScrollController = ScrollController();
  ScrollController _ongoingScrollController = ScrollController();
  ScrollController _completedScrollController = ScrollController();
  bool searcher = false;
  // _OrderListScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(MdiIcons.arrowLeft),
                ),
              ),
              centerTitle: true,
              title: Text("Local orders"),
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
            body: RefreshIndicator(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                _isDataLoaded = false;
                _isAllOrderPending = true;
                setState(() {});
                _allOrderList.clear();

                await _init();
                return null;
              },
              child: _isDataLoaded
                  ? Column(
                      children: [
                        if (searcher)
                          Focus(
                            onFocusChange: (bool focus) {
                              if (!focus) {
                                _isAllOrderPending = true;
                                _getAllOrder();
                              }
                            },
                            child: TextFormField(
                              controller: search,
                              decoration:
                                  InputDecoration(hintText: "Search order"),
                            ),
                          ),
                        Container(child: _allOrders()),
                      ],
                    )
                  : _shimmerWidget(),
            ),
          ),
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
    _init();
  }

  Widget _allOrders() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _allOrderList.length > 0
          ? SingleChildScrollView(
              controller: _allOrderScrollController,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _allOrderList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LocalOrderDetailScreen(
                                    _allOrderList[index],
                                    a: widget.analytics,
                                    o: widget.observer),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      color: global.isDarkModeEnable
                                          ? Color(0xFF373C58)
                                          : Color(0xFFF2F5F8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Text(
                                      _allOrderList[index].cartId,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2,
                                    ),
                                  ),
                                  Text(
                                    _allOrderList[index].orderDate,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                  Row(children: [
                                    Icon(
                                      _allOrderList[index].orderStatus ==
                                              'Cancelled'
                                          ? MdiIcons.closeOctagon
                                          : MdiIcons.checkDecagram,
                                      size: 20,
                                      color: _allOrderList[index].orderStatus ==
                                              'Cancelled'
                                          ? Colors.red
                                          : _allOrderList[index].orderStatus ==
                                                  'Completed'
                                              ? Colors.greenAccent
                                              : _allOrderList[index]
                                                          .orderStatus ==
                                                      'Confirmed'
                                                  ? Colors.blue
                                                  : _allOrderList[index]
                                                              .orderStatus ==
                                                          'Pending'
                                                      ? Colors.yellow
                                                      : Theme.of(context)
                                                          .primaryColorLight,
                                    ),
                                    Padding(
                                      padding: global.isRTL
                                          ? EdgeInsets.only(right: 8)
                                          : EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        _allOrderList[index].orderStatus,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2,
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _allOrderList[index].userName,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1,
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    Padding(
                                      padding: global.isRTL
                                          ? EdgeInsets.only(right: 8)
                                          : EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        _allOrderList[index].timeSlot ??
                                            "0 min",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2,
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Divider(
                                color: global.isDarkModeEnable
                                    ? Theme.of(context)
                                        .dividerTheme
                                        .color
                                        .withOpacity(0.05)
                                    : Theme.of(context).dividerTheme.color,
                              ),
                            ],
                          ),
                        );
                      }),
                  _isAllOrderMoreDataLoaded
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : SizedBox()
                ],
              ),
            )
          : Center(
              child: Text(
                "${AppLocalizations.of(context).txt_nothing_to_show}",
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
            ),
    );
  }

  _init() async {
    try {
      await _getAllOrder();
      _allOrderScrollController.addListener(() async {
        if (_allOrderScrollController.position.pixels ==
                _allOrderScrollController.position.maxScrollExtent &&
            !_isAllOrderMoreDataLoaded) {
          setState(() {
            _isAllOrderMoreDataLoaded = true;
          });
          await _getAllOrder();
          setState(() {
            _isAllOrderMoreDataLoaded = false;
          });
        }
      });

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print(
          "Exception - OfflineOrderListScreen.dart - _init(): " + e.toString());
    }
  }

  _getAllOrder() async {
    try {
      if (_isAllOrderPending) {
        setState(() {
          _isAllOrderMoreDataLoaded = true;
        });
        if (_allOrderList.isEmpty) {
          _allOrderPage = 1;
        } else {
          _allOrderPage++;
        }
        await apiHelper
            .myOfflineOrders(_allOrderPage, search.text)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Order> _tList = result.data;
              if (_tList.isEmpty) {
                _isAllOrderPending = false;
              }

              setState(() {
                _allOrderList = _tList;
                _isAllOrderMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - OfflineOrderListScreen.dart - _getAllOrder():" +
          e.toString());
    }
  }

  Widget _shimmerWidget() {
    try {
      return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Card(),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ));
    } catch (e) {
      print("Exception - walletScreen.dart - _shimmerWidget():" + e.toString());
      return SizedBox();
    }
  }
}
