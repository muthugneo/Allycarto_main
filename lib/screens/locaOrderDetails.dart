import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/orderModel.dart';
import 'package:gomeat/screens/cancelOrderScreen.dart';
import 'package:gomeat/screens/checkOutScreen.dart';
import 'package:gomeat/screens/mapScreen.dart';
import 'package:gomeat/screens/productDetailScreen.dart';
import 'package:gomeat/screens/rateOrderScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LocalOrderDetailScreen extends BaseRoute {
  final Order order;
  LocalOrderDetailScreen(this.order, {a, o})
      : super(a: a, o: o, r: 'LocalOrderDetailScreen');
  @override
  _OrderDetailScreenState createState() =>
      new _OrderDetailScreenState(this.order);
}

class _OrderDetailScreenState extends BaseRouteState {
  Order order;

  GlobalKey<ScaffoldState> _scaffoldKey;
  _OrderDetailScreenState(this.order) : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          title: Text(
              "#${order.cartId} - ${AppLocalizations.of(context).tle_order_details}"),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            getOrderDetails();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Description",
                      style: Theme.of(context).primaryTextTheme.headline5,
                    ),
                  ),
                  Text(
                    order.description ?? "",
                    style: Theme.of(context).primaryTextTheme.overline,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context).txt_status}",
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                      Expanded(child: SizedBox()),
                      Icon(
                        order.orderStatus == 'Cancelled'
                            ? MdiIcons.closeOctagon
                            : MdiIcons.checkDecagram,
                        size: 20,
                        color: order.orderStatus == 'Cancelled'
                            ? Colors.red
                            : order.orderStatus == 'Completed'
                                ? Colors.greenAccent
                                : order.orderStatus == 'Confirmed'
                                    ? Colors.blue
                                    : order.orderStatus == 'Pending'
                                        ? Colors.yellow
                                        : Theme.of(context).primaryColorLight,
                      ),
                      Text(
                        order.orderStatus,
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Duration",
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                      Text(
                        "${order.timeSlot ?? "0 min"}",
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Otp",
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                      Text(
                        "${order.otp ?? "None"}",
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                    ],
                  ),
                ],
              ),
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
    getOrderDetails();
  }

  getOrderDetails() async {
    try {
      bool _isConnected = await br.checkConnectivity();
      if (_isConnected) {
        showOnlyLoaderDialog();
        await apiHelper
            .getOfflineOrderDetails(order.cartId)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              setState(() {
                order = result.data;
              });
            } else {
              hideLoader();
              showSnackBar(
                  key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - LocalOrderDetailScreen.dart - _reOrder():" +
          e.toString());
    }
  }
}
