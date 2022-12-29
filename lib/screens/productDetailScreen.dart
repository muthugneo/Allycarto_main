import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/productDetailModel.dart';
import 'package:gomeat/screens/checkOutScreen.dart';
import 'package:gomeat/screens/new/shop_products.dart';
import 'package:gomeat/screens/productListScreen.dart';
import 'package:gomeat/screens/ratingListScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends BaseRoute {
  final int productId;
  final int varientId;
  final ProductDetail productDetail;
  ProductDetailScreen(
      {a, o, this.productDetail, this.productId, this.varientId})
      : super(a: a, o: o, r: 'ProductDetailScreen');
  @override
  _ProductDetailScreenState createState() => new _ProductDetailScreenState(
      this.productId, this.varientId, this.productDetail);
}

class _ProductDetailScreenState extends BaseRouteState {
  int productId;
  int varientId;
  GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDataLoaded = false;
  ProductDetail productDetail;
  ProductDetail _productDetail = new ProductDetail();
  _ProductDetailScreenState(this.productId, this.varientId, this.productDetail)
      : super();
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;
  String chosingIndex = "Product Description";
  List<String> choseeList = ["10 MI", "50 MI", "100 Mi"];
  bool howToUse = false;
  bool productDes = false;
List<String> produDes=["Product Description","Benefits"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text("${AppLocalizations.of(context).tle_product_details}"),
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
            actions: [
              global.currentUser.cartCount != null &&
                      global.currentUser.cartCount > 0
                  ? FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      heroTag: null,
                      child: Badge(
                        badgeContent: Text(
                          "${global.currentUser.cartCount}",
                          style: TextStyle(color: Colors.white, fontSize: 08),
                        ),
                        padding: EdgeInsets.all(6),
                        badgeColor: Colors.red,
                        child: Icon(
                          MdiIcons.shoppingOutline,
                          color: Theme.of(context)
                              .appBarTheme
                              .actionsIconTheme
                              .color,
                        ),
                      ),
                      mini: true,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                                a: widget.analytics, o: widget.observer),
                          ),
                        );
                      },
                    )
                  : FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      heroTag: null,
                      child: Icon(
                        MdiIcons.shoppingOutline,
                        color: Theme.of(context)
                            .appBarTheme
                            .actionsIconTheme
                            .color,
                      ),
                      mini: true,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                                a: widget.analytics, o: widget.observer),
                          ),
                        );
                      },
                    ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _isDataLoaded
                        ? _productDetail != null &&
                                _productDetail.productDetail != null
                            ? Container(
                                // height: 270,
                                margin: EdgeInsets.only(top: 0),
                                child: Column(
                                  // clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: global.isDarkModeEnable
                                          ? BoxDecoration(
                                              gradient: LinearGradient(
                                                stops: [0, .90],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF545975)
                                                      .withOpacity(0.44),
                                                  Color(0xFF333550)
                                                      .withOpacity(0.22)
                                                ],
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            )
                                          : BoxDecoration(
                                              gradient: LinearGradient(
                                                stops: [0, .90],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF7C96AA)
                                                      .withOpacity(0.33),
                                                  Color(0xFFA6C1D6)
                                                      .withOpacity(0.07)
                                                ],
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (_productDetail
                                                                .productDetail
                                                                .images !=
                                                            null &&
                                                        _productDetail
                                                            .productDetail
                                                            .images
                                                            .isNotEmpty) {
                                                      dialogToOpenImage(
                                                          _productDetail
                                                              .productDetail
                                                              .productName,
                                                          _productDetail
                                                              .productDetail
                                                              .images,
                                                          0);
                                                    }
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        child: CachedNetworkImage(
                                                          imageUrl: global.appInfo
                                                                  .imageUrl +
                                                              _productDetail
                                                                  .productDetail
                                                                  .productImage,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                            alignment:
                                                                Alignment.center,
                                                            child: Visibility(
                                                              visible: _productDetail
                                                                          .productDetail
                                                                          .stock >
                                                                      0
                                                                  ? false
                                                                  : true,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorLight
                                                                        .withOpacity(
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15)),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                                  child: Text(
                                                                    '${AppLocalizations.of(context).txt_out_of_stock}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .primaryTextTheme
                                                                        .headline2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            child: Visibility(
                                                              visible: _productDetail
                                                                          .productDetail
                                                                          .stock >
                                                                      0
                                                                  ? false
                                                                  : true,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorLight
                                                                        .withOpacity(
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15)),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                                  child: Text(
                                                                    '${AppLocalizations.of(context).txt_out_of_stock}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .primaryTextTheme
                                                                        .headline2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            alignment:
                                                                Alignment.center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    '${global.defaultImage}'),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        height: 160,
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                      ),
                                                      if (_productDetail
                                                                  .productDetail
                                                                  .discount !=
                                                              null &&
                                                          _productDetail
                                                                  .productDetail
                                                                  .discount >
                                                              0)
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 20,
                                                            width: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.green,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(10),
                                                                bottomLeft: Radius
                                                                    .circular(10),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "${_productDetail.productDetail.discount}% ${AppLocalizations.of(context).txt_off}",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: Theme.of(
                                                                      context)
                                                                  .primaryTextTheme
                                                                  .caption,
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width,
                                                  child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: _productDetail
                                                          .productDetail.images.length??0,
                                                    itemBuilder: (context, imIndex){
                                                    return InkWell(
                                                        onTap: () {
                                                            if (_productDetail
                                                                        .productDetail
                                                                        .images !=
                                                                    null &&
                                                                _productDetail
                                                                    .productDetail
                                                                    .images
                                                                    .isNotEmpty) {
                                                              dialogToOpenImage(
                                                                  _productDetail
                                                                      .productDetail
                                                                      .productName,
                                                                  _productDetail
                                                                      .productDetail
                                                                      .images,
                                                                  imIndex);
                                                            }
                                                          },
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: CachedNetworkImage(
                                                          imageUrl:"${global.appInfo
                                                                    .imageUrl}${_productDetail
                                                                  .productDetail
                                                                  .images[imIndex].image}",
                                                                // ${_productDetail
                                                                //   .productDetail
                                                                //   .images[imIndex].image}',
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                child: CircularProgressIndicator(
                                                                    value:
                                                                        downloadProgress
                                                                            .progress),
                                                              ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${global.appInfo.currencySign}. ${_productDetail.productDetail.mrp} ',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .headline2
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '${global.appInfo.currencySign}. ${_productDetail.productDetail.price} ',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyText1,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${_productDetail.productDetail.productName}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      IconButton(
                                                          onPressed: () async {
                                                            bool _isAdded =
                                                                await addRemoveWishList(
                                                                    _productDetail
                                                                        .productDetail
                                                                        .storeId
                                                                        .toString(),
                                                                    _productDetail
                                                                        .productDetail
                                                                        .varientId,
                                                                    _scaffoldKey);
                                                            if (_isAdded) {
                                                              _productDetail
                                                                      .productDetail
                                                                      .isFavourite =
                                                                  !_productDetail
                                                                      .productDetail
                                                                      .isFavourite;
                                                            }

                                                            setState(() {});
                                                          },
                                                          icon: _productDetail
                                                                  .productDetail
                                                                  .isFavourite
                                                              ? Icon(
                                                                  MdiIcons.heart,
                                                                  size: 20,
                                                                  color: Color(
                                                                      0xFFEF5656),
                                                                )
                                                              : Icon(
                                                                  MdiIcons.heartOutline,
                                                                  size: 20,
                                                                  color: Color(
                                                                      0xFF4A4352),
                                                                )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  alignment: Alignment.centerLeft,
                                                  child: Wrap(
                                                    runSpacing: 0,
                                                    spacing: 10,
                                                    children: _tagWidgetList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Product Information",
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13)),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.40,
                                                        child: Text(
                                                          "Product ID",
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .button
                                                              .copyWith(
                                                                  fontSize: 13),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                            '${_productDetail.productDetail.productId}',
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .button
                                                                .copyWith(
                                                                    fontSize:
                                                                        13)),
                                                      )
                                                    ]),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.40,
                                                        child: Text(
                                                            "Available Variants",
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .button
                                                                .copyWith(
                                                                    fontSize:
                                                                        13)),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                            getVarientsString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .button
                                                                .copyWith(
                                                                    fontSize:
                                                                        13)),
                                                      )
                                                    ]),
                                                    SizedBox(
                                                      height: 15,
                                                    )
                                                  ],
                                                ),
                                              )),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            child: Column(children: [
                                              Row(
                                                children: produDes.map((e) => InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      productDes=false;
                                                      chosingIndex=e;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width*0.47,
                                                    height: 40,
                                                    color: chosingIndex==e?Colors.white:Colors.grey[300],
                                                    child: Center(child: Text(e,
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .bodyText1
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        13)),)
                                                                                            ),
                                                )).toList(),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: Text(
                                                       chosingIndex=="Product Description"?( _productDetail
                                                                .productDetail
                                                                .product_description
                                                                .isNotEmpty
                                                            ? "${_productDetail.productDetail.product_description.substring(0, productDes ? _productDetail.productDetail.product_description.length : _productDetail.productDetail.product_description.length < 80 ? _productDetail.productDetail.product_description.length : 80)}${productDes ? '' : _productDetail.productDetail.product_description.length < 80 ? '' : '...'}"
                                                            : ''): (_productDetail
                                                              .productDetail
                                                              .benifits
                                                              .isNotEmpty
                                                          ? "${_productDetail.productDetail.benifits.substring(0, productDes ? _productDetail.productDetail.benifits.length : _productDetail.productDetail.benifits.length < 80 ? _productDetail.productDetail.benifits.length : 80)}${productDes ? '' : _productDetail.productDetail.benifits.length < 80 ? '' : '...'}"
                                                          : ''),
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .button
                                                            .copyWith(fontSize: 13),
                                                      ),
                                              ),
                                              if (chosingIndex=="Product Description"&&_productDetail
                                                      .productDetail
                                                      .product_description
                                                      .length >
                                                  80)
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          productDes = !productDes;
                                                        });
                                                      },
                                                      child: Text(productDes?"Less":"More",
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .button
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .blue)),
                                                    ),
                                                  ],
                                                ),
                                              if (chosingIndex ==
                                                      "Benefits" &&
                                                  _productDetail.productDetail
                                                          .benifits.length >
                                                      80)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          productDes =
                                                              !productDes;
                                                        });
                                                      },
                                                      child: Text(
                                                          productDes
                                                              ? "Less"
                                                              : "More",
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .button
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .blue)),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("How to Use?",
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13)),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      _productDetail
                                                              .productDetail
                                                              .how_to_use
                                                              .isNotEmpty
                                                          ? "${_productDetail.productDetail.how_to_use.substring(0, howToUse ? _productDetail.productDetail.how_to_use.length : _productDetail.productDetail.how_to_use.length < 80 ? _productDetail.productDetail.how_to_use.length : 80)}${howToUse ? '' : _productDetail.productDetail.how_to_use.length < 80 ? '' : '...'}"
                                                          : '',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .button
                                                          .copyWith(fontSize: 13),
                                                    ),
                                                    if(_productDetail
                                                            .productDetail
                                                            .how_to_use
                                                            .length >
                                                        80)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              howToUse =
                                                                  !howToUse;
                                                            });
                                                          },
                                                          child: Text(
                                                                howToUse
                                                                    ? "Less"
                                                                    : "More",
                                                              style: Theme.of(
                                                                      context)
                                                                  .primaryTextTheme
                                                                  .button
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .blue)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                    // RichText(
                                                    //   text: TextSpan(
                                                    //     text:
                                                    //         "${_productDetail.productDetail.product_description} ",
                                                    //     style: Theme.of(context)
                                                    //         .primaryTextTheme
                                                    //         .bodyText1,
                                                    //     children: [
                                                    //       TextSpan(
                                                    //         text:
                                                    //             'more',
                                                    //         style: Theme.of(context)
                                                    //             .primaryTextTheme
                                                    //             .bodyText1,
                                                    //          recognizer:
                                                    //               TapGestureRecognizer()
                                                    //                 ..onTap =(){}
                                                    //       ),

                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              )),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     SizedBox(width: 5,),
                                          //     Text(
                                          //       '${_productDetail.productDetail.productName}',
                                          //       textAlign: TextAlign.center,
                                          //       style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(fontWeight: FontWeight.bold,fontSize: 13),
                                          //     ),
                                          //     Column(
                                          //       mainAxisSize: MainAxisSize.min,
                                          //       mainAxisAlignment: MainAxisAlignment.start,
                                          //       crossAxisAlignment: CrossAxisAlignment.end,
                                          //       children: [
                                          //         // _productDetail.productDetail.discount != null && _productDetail.productDetail.discount > 0
                                          //         //     ? Container(
                                          //         //   height: 20,
                                          //         //   width: 70,
                                          //         //   decoration: BoxDecoration(
                                          //         //     color: Colors.green,
                                          //         //     borderRadius: BorderRadius.only(
                                          //         //       topRight: Radius.circular(10),
                                          //         //       bottomLeft: Radius.circular(10),
                                          //         //     ),
                                          //         //   ),
                                          //         //   child: Text(
                                          //         //     "${_productDetail.productDetail.discount}% ${AppLocalizations.of(context).txt_off}",
                                          //         //     textAlign: TextAlign.center,
                                          //         //     style: Theme.of(context).primaryTextTheme.caption,
                                          //         //   ),
                                          //         // )
                                          //         //     : SizedBox(
                                          //         //   height: 20,
                                          //         //   width: 60,
                                          //         // ),
                                          //         IconButton(
                                          //             onPressed: () async {
                                          //               bool _isAdded = await addRemoveWishList(_productDetail.productDetail.storeId.toString(),_productDetail.productDetail.varientId, _scaffoldKey);
                                          //               if (_isAdded) {
                                          //                 _productDetail.productDetail.isFavourite = !_productDetail.productDetail.isFavourite;
                                          //               }

                                          //               setState(() {});
                                          //             },
                                          //             icon: _productDetail.productDetail.isFavourite
                                          //                 ? Icon(
                                          //               MdiIcons.heart,
                                          //               size: 20,
                                          //               color: Color(0xFFEF5656),
                                          //             )
                                          //                 : Icon(
                                          //               MdiIcons.heart,
                                          //               size: 20,
                                          //               color: Color(0xFF4A4352),
                                          //             )),
                                          //       ],
                                          //     )
                                          //   ],
                                          // ),
                                          // Container(
                                          //     child: RichText(
                                          //   text: TextSpan(
                                          //     text:
                                          //         '${_productDetail.productDetail.product_description}',
                                          //     style: Theme.of(context)
                                          //         .primaryTextTheme
                                          //         .button
                                          //         .copyWith(fontSize: 13),
                                          //     children: [
                                          //       TextSpan(
                                          //           text: 'more',
                                          //           style: Theme.of(context)
                                          //               .primaryTextTheme
                                          //               .bodyText1,
                                          //           recognizer:
                                          //               TapGestureRecognizer()
                                          //                 ..onTap = () {}),
                                          //     ],
                                          //   ),
                                          // )),
                                          // Padding(
                                          //   padding: EdgeInsets.only(top: 0),
                                          //   child: Text(
                                          //     '${_productDetail.productDetail.type}',
                                          //     textAlign: TextAlign.center,
                                          //     style: Theme.of(context)
                                          //         .primaryTextTheme
                                          //         .button
                                          //         .copyWith(
                                          //             fontSize: 14,
                                          //             color: Colors.blue),
                                          //   ),
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Text(
                                          //       "   Description : ",
                                          //       style: Theme.of(context)
                                          //           .primaryTextTheme
                                          //           .button
                                          //           .copyWith(fontSize: 13),
                                          //     )
                                          //   ],
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(
                                          //       top: 2, left: 16, right: 16),
                                          //   child: Text(
                                          //     '${_productDetail.productDetail.product_description}',
                                          //     style: Theme.of(context)
                                          //         .primaryTextTheme
                                          //         .button
                                          //         .copyWith(fontSize: 13),
                                          //     textAlign: TextAlign.start,
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(top: 6),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.min,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.spaceBetween,
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.center,
                                          //     children: [
                                          //       Row(
                                          //         children: [
                                          //           RichText(
                                          //             text: TextSpan(
                                          //               text:
                                          //                   "${global.appInfo.currencySign}. ",
                                          //               style: Theme.of(context)
                                          //                   .primaryTextTheme
                                          //                   .bodyText1,
                                          //               children: [
                                          //                 TextSpan(
                                          //                   text:
                                          //                       '${_productDetail.productDetail.price} ',
                                          //                   style: Theme.of(
                                          //                           context)
                                          //                       .primaryTextTheme
                                          //                       .bodyText1,
                                          //                 ),
                                          //                 TextSpan(
                                          //                   text: ' /  ',
                                          //                   style: Theme.of(
                                          //                           context)
                                          //                       .primaryTextTheme
                                          //                       .bodyText1,
                                          //                 ),
                                          //                 TextSpan(
                                          //                   text:
                                          //                       '${global.appInfo.currencySign}. ${_productDetail.productDetail.mrp} ',
                                          //                   style: Theme.of(
                                          //                           context)
                                          //                       .primaryTextTheme
                                          //                       .headline2
                                          //                       .copyWith(
                                          //                           decoration:
                                          //                               TextDecoration
                                          //                                   .lineThrough),
                                          //                 ),
                                          //                 TextSpan(
                                          //                   text:
                                          //                       '    ${_productDetail.productDetail.quantity} ${_productDetail.productDetail.unit} ',
                                          //                   style: Theme.of(
                                          //                           context)
                                          //                       .primaryTextTheme
                                          //                       .headline2
                                          //                       .copyWith(
                                          //                           fontSize: 14,
                                          //                           color: Colors
                                          //                               .black87),
                                          //                 ),
                                          //                 // TextSpan(
                                          //                 //   text: ' ${_productDetail.productDetail.mrp}',
                                          //                 //   style: Theme.of(context).primaryTextTheme.headline2.copyWith(decoration: TextDecoration.lineThrough),
                                          //                 // ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //           _productDetail.productDetail
                                          //                           .rating !=
                                          //                       null &&
                                          //                   _productDetail
                                          //                           .productDetail
                                          //                           .rating >
                                          //                       0
                                          //               ? Icon(
                                          //                   Icons.star,
                                          //                   size: 18,
                                          //                   color: Theme.of(
                                          //                           context)
                                          //                       .primaryColorLight,
                                          //                 )
                                          //               : SizedBox(),
                                          //           _productDetail.productDetail
                                          //                           .rating !=
                                          //                       null &&
                                          //                   _productDetail
                                          //                           .productDetail
                                          //                           .rating >
                                          //                       0
                                          //               ? InkWell(
                                          //                   onTap: () {
                                          //                     Navigator.of(
                                          //                             context)
                                          //                         .push(
                                          //                       MaterialPageRoute(
                                          //                         builder: (context) => RatingListScreen(
                                          //                             _productDetail
                                          //                                 .productDetail
                                          //                                 .varientId,
                                          //                             a: widget
                                          //                                 .analytics,
                                          //                             o: widget
                                          //                                 .observer),
                                          //                       ),
                                          //                     );
                                          //                   },
                                          //                   child: RichText(
                                          //                     text: TextSpan(
                                          //                       text:
                                          //                           "${_productDetail.productDetail.rating} ",
                                          //                       style: Theme.of(
                                          //                               context)
                                          //                           .primaryTextTheme
                                          //                           .bodyText1,
                                          //                       children: [
                                          //                         TextSpan(
                                          //                           text: '|',
                                          //                           style: Theme.of(
                                          //                                   context)
                                          //                               .primaryTextTheme
                                          //                               .headline2,
                                          //                         ),
                                          //                         TextSpan(
                                          //                           text:
                                          //                               ' ${_productDetail.productDetail.ratingCount} ${AppLocalizations.of(context).txt_ratings}',
                                          //                           style: Theme.of(
                                          //                                   context)
                                          //                               .primaryTextTheme
                                          //                               .headline1,
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 )
                                          //               : SizedBox(),
                                          //         ],
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShopProductListScreen(
                                                          1,
                                                          _productDetail
                                                              .productDetail
                                                              .shop_name,
                                                          _productDetail
                                                              .productDetail
                                                              .storeId
                                                              .toString(),
                                                          subcategoryId:
                                                              _productDetail
                                                                  .productDetail
                                                                  .storeId,
                                                          a: widget.analytics,
                                                          o: widget.observer),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0, left: 16, right: 16),
                                              child: Text(
                                                '${_productDetail.productDetail.shop_name}',
                                                style:
                                                    TextStyle(color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          _productDetail.productDetail.stock > 0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(10),
                                                          topLeft:
                                                              Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: FlatButton(
                                                        child: Text(
                                                          '   ADD   ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        visualDensity:
                                                            VisualDensity(
                                                                vertical: -4,
                                                                horizontal: -4),
                                                        onPressed: () async {
                                                          await addToCartShowModalBottomSheet(
                                                              _productDetail
                                                                  .productDetail,
                                                              _scaffoldKey);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),

                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Positioned(
                                    //   left: (MediaQuery.of(context).size.width - 231) / 2,
                                    //   top: -45,
                                    //   child: Builder(builder: (context) {
                                    //     return InkWell(
                                    //       onTap: () {
                                    //         if (_productDetail.productDetail.images != null && _productDetail.productDetail.images.isNotEmpty) {
                                    //           dialogToOpenImage(_productDetail.productDetail.productName, _productDetail.productDetail.images, 0);
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         child: CachedNetworkImage(
                                    //           imageUrl: global.appInfo.imageUrl + _productDetail.productDetail.productImage,
                                    //           imageBuilder: (context, imageProvider) => Container(
                                    //             decoration: BoxDecoration(
                                    //               borderRadius: BorderRadius.circular(15),
                                    //               image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    //             ),
                                    //             alignment: Alignment.center,
                                    //             child: Visibility(
                                    //               visible: _productDetail.productDetail.stock > 0 ? false : true,
                                    //               child: Container(
                                    //                 alignment: Alignment.center,
                                    //                 decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                                    //                 child: Container(
                                    //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                    //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    //                   child: Text(
                                    //                     '${AppLocalizations.of(context).txt_out_of_stock}',
                                    //                     style: Theme.of(context).primaryTextTheme.headline2,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    //           errorWidget: (context, url, error) => Container(
                                    //             child: Visibility(
                                    //               visible: _productDetail.productDetail.stock > 0 ? false : true,
                                    //               child: Container(
                                    //                 alignment: Alignment.center,
                                    //                 decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                                    //                 child: Container(
                                    //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                    //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    //                   child: Text(
                                    //                     '${AppLocalizations.of(context).txt_out_of_stock}',
                                    //                     style: Theme.of(context).primaryTextTheme.headline2,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             alignment: Alignment.center,
                                    //             decoration: BoxDecoration(
                                    //               borderRadius: BorderRadius.circular(15),
                                    //               image: DecorationImage(
                                    //                 image: AssetImage('${global.defaultImage}'),
                                    //                 fit: BoxFit.cover,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         height: 160,
                                    //         width: 215,
                                    //       ),
                                    //     );
                                    //   }),
                                    // ),
                                    // Positioned(
                                    //     bottom: 0,
                                    //     right: 0,
                                    //     child: _productDetail.productDetail.stock > 0
                                    //         ?
                                    //     Container(
                                    //       height: 30,
                                    //       width: 60,
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.orange,
                                    //         borderRadius: BorderRadius.only(
                                    //           bottomRight: Radius.circular(10),
                                    //           topLeft: Radius.circular(10),
                                    //         ),
                                    //       ),
                                    //       child:
                                    //       FlatButton(
                                    //         child: Text('ADD',style: TextStyle(color: Colors.white),),
                                    //
                                    //         padding: EdgeInsets.all(0),
                                    //
                                    //         visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    //
                                    //         onPressed: () async {
                                    //           await addToCartShowModalBottomSheet(_productDetail.productDetail, _scaffoldKey);
                                    //
                                    //         },
                                    //       ),
                                    //     )
                                    //         : SizedBox()),
                                    // Positioned(
                                    //   right: 0,
                                    //   top: 0,
                                    //   child: Column(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     crossAxisAlignment: CrossAxisAlignment.end,
                                    //     children: [
                                    //       _productDetail.productDetail.discount != null && _productDetail.productDetail.discount > 0
                                    //           ? Container(
                                    //               height: 20,
                                    //               width: 70,
                                    //               decoration: BoxDecoration(
                                    //                 color: Colors.green,
                                    //                 borderRadius: BorderRadius.only(
                                    //                   topRight: Radius.circular(10),
                                    //                   bottomLeft: Radius.circular(10),
                                    //                 ),
                                    //               ),
                                    //               child: Text(
                                    //                 "${_productDetail.productDetail.discount}% ${AppLocalizations.of(context).txt_off}",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: Theme.of(context).primaryTextTheme.caption,
                                    //               ),
                                    //             )
                                    //           : SizedBox(
                                    //               height: 20,
                                    //               width: 60,
                                    //             ),
                                    //       IconButton(
                                    //           onPressed: () async {
                                    //             bool _isAdded = await addRemoveWishList(_productDetail.productDetail.storeId.toString(),_productDetail.productDetail.varientId, _scaffoldKey);
                                    //             if (_isAdded) {
                                    //               _productDetail.productDetail.isFavourite = !_productDetail.productDetail.isFavourite;
                                    //             }
                                    //
                                    //             setState(() {});
                                    //           },
                                    //           icon: _productDetail.productDetail.isFavourite
                                    //               ? Icon(
                                    //                   MdiIcons.heart,
                                    //                   size: 20,
                                    //                   color: Color(0xFFEF5656),
                                    //                 )
                                    //               : Icon(
                                    //                   MdiIcons.heart,
                                    //                   size: 20,
                                    //                   color: Color(0xFF4A4352),
                                    //                 )),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : Text('No Product Found')
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 285,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(),
                                ),
                              ],
                            ),
                          ),

// Similar products
                    _isDataLoaded &&
                            _productDetail.similarProductList != null &&
                            _productDetail.similarProductList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                "${AppLocalizations.of(context).lbl_similar_products}",
                                style:
                                    Theme.of(context).primaryTextTheme.headline5,
                              ),
                            ),
                          )
                        : SizedBox(),
                    _isDataLoaded
                        ? _productDetail.similarProductList != null &&
                                _productDetail.similarProductList.length > 0
                            ? ListView.builder(
                                itemCount:
                                    _productDetail.similarProductList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    productId: _productDetail
                                                        .similarProductList[index]
                                                        .productId,
                                                    a: widget.analytics,
                                                    o: widget.observer),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 110,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .cardTheme
                                                    .color,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 130),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment: global.isRTL
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${_productDetail.similarProductList[index].productName}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      '${_productDetail.similarProductList[index].type}',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .headline2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${global.appInfo.currencySign} ",
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .headline2,
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                '${_productDetail.similarProductList[index].price}',
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .bodyText1,
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                ' / ${_productDetail.similarProductList[index].quantity} ${_productDetail.similarProductList[index].unit}',
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .headline2,
                                                          )
                                                        ])),
                                                    _productDetail.productDetail
                                                                    .rating !=
                                                                null &&
                                                            _productDetail
                                                                    .productDetail
                                                                    .rating >
                                                                0
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  size: 18,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                                ),
                                                                RichText(
                                                                  text: TextSpan(
                                                                    text:
                                                                        "${_productDetail.productDetail.rating} ",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .primaryTextTheme
                                                                        .bodyText1,
                                                                    children: [
                                                                      TextSpan(
                                                                        text: '|',
                                                                        style: Theme.of(
                                                                                context)
                                                                            .primaryTextTheme
                                                                            .headline2,
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ${_productDetail.productDetail.ratingCount} ${AppLocalizations.of(context).txt_ratings}',
                                                                        style: Theme.of(
                                                                                context)
                                                                            .primaryTextTheme
                                                                            .headline1,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                _productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .discount !=
                                                            null &&
                                                        _productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .discount >
                                                            0
                                                    ? Container(
                                                        height: 20,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "${_productDetail.similarProductList[index].discount}% ${AppLocalizations.of(context).txt_off}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .caption,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 20,
                                                        width: 60,
                                                      ),
                                                IconButton(
                                                    onPressed: () async {
                                                      bool _isAdded =
                                                          await addRemoveWishList(
                                                              _productDetail
                                                                  .similarProductList[
                                                                      index]
                                                                  .storeId
                                                                  .toString(),
                                                              _productDetail
                                                                  .similarProductList[
                                                                      index]
                                                                  .varientId,
                                                              _scaffoldKey);
                                                      if (_isAdded) {
                                                        _productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .isFavourite =
                                                            !_productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .isFavourite;
                                                      }

                                                      setState(() {});
                                                    },
                                                    icon: _productDetail
                                                            .similarProductList[
                                                                index]
                                                            .isFavourite
                                                        ? Icon(
                                                            MdiIcons.heart,
                                                            size: 20,
                                                            color:
                                                                Color(0xFFEF5656),
                                                          )
                                                        : Icon(
                                                            MdiIcons.heart,
                                                            size: 20,
                                                            color:
                                                                Color(0xFF4A4352),
                                                          ))
                                              ],
                                            ),
                                          ),
                                          _productDetail.similarProductList[index]
                                                      .stock >
                                                  0
                                              ? Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 30,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: FlatButton(
                                                      child: Text(
                                                        'ADD',
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      padding: EdgeInsets.all(0),
                                                      visualDensity:
                                                          VisualDensity(
                                                              vertical: -4,
                                                              horizontal: -4),
                                                      onPressed: () async {
                                                        await addToCartShowModalBottomSheet(
                                                            _productDetail
                                                                    .similarProductList[
                                                                index],
                                                            _scaffoldKey);
                                                      },
                                                    ),
                                                    // IconButton(
                                                    //   padding: EdgeInsets.all(0),
                                                    //   visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                                    //   onPressed: () async {
                                                    //     await addToCartShowModalBottomSheet(_productDetail.similarProductList[index], _scaffoldKey);
                                                    //   },
                                                    //   icon: Icon(
                                                    //     Icons.add,
                                                    //     color: Theme.of(context).primaryTextTheme.caption.color,
                                                    //   ),
                                                    // ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          Positioned(
                                            left: 0,
                                            top: -10,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 6),
                                              child: CachedNetworkImage(
                                                imageUrl: global
                                                        .appInfo.imageUrl +
                                                    _productDetail
                                                        .similarProductList[index]
                                                        .productImage,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Visibility(
                                                    visible: _productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .stock >
                                                            0
                                                        ? false
                                                        : true,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context)
                                                              .primaryColorLight
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15)),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5)),
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                        child: Text(
                                                          '${AppLocalizations.of(context).txt_out_of_stock}',
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .headline2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) => Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  child: Visibility(
                                                    visible: _productDetail
                                                                .similarProductList[
                                                                    index]
                                                                .stock >
                                                            0
                                                        ? false
                                                        : true,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context)
                                                              .primaryColorLight
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15)),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5)),
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                        child: Text(
                                                          '${AppLocalizations.of(context).txt_out_of_stock}',
                                                          style: Theme.of(context)
                                                              .primaryTextTheme
                                                              .headline2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          '${global.defaultImage}'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              height: 100,
                                              width: 120,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : SizedBox()
                        : _similarProductShimmer()
                  ],
                ),
              ),
            ),
          )),
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

  _init() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (varientId != null) {
          await apiHelper.getBannerVarient(varientId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _productDetail = result.data;
              } else if (result.status == "0") {
                _productDetail = null;
              }
            }
          });
        } else if (productDetail != null) {
          _productDetail = productDetail;
        } else {
          await apiHelper.getProductDetail(productId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _productDetail = result.data;
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productDetailScreen.dart- _init():" + e.toString());
    }
  }

  Widget _similarProductShimmer() {
    try {
      return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - productDetailScreen.dart - _similarProductShimmer():" +
          e.toString());
      return SizedBox();
    }
  }

  List<Widget> _tagWidgetList() {
    List<Widget> _widgetList = [];
    try {
      for (int i = 0; i < _productDetail.productDetail.tags.length; i++) {
        _widgetList.add(
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                      8, _productDetail.productDetail.tags[i].tag, "",
                      a: widget.analytics, o: widget.observer),
                ),
              );
            },
            child: Chip(
              padding: EdgeInsets.zero,
              backgroundColor: Theme.of(context).iconTheme.color,
              label: Text(
                '${_productDetail.productDetail.tags[i].tag}',
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).primaryTextTheme.caption.color,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }

      return _widgetList;
    } catch (e) {
      print("Exception - productDetailScreen.dart -  _tagWidgetList():" +
          e.toString());
      _widgetList.add(SizedBox());
      return _widgetList;
    }
  }

  String getVarientsString() {
    String _avalableVariants = "";
    try {
      for (int i = 0; i < _productDetail.productDetail.tags.length; i++) {
        _avalableVariants =
            _avalableVariants + '${_productDetail.productDetail.tags[i].tag}';
      }

      return _avalableVariants;
    } catch (e) {
      return "";
    }
  }
}
