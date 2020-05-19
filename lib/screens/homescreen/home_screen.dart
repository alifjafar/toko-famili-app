import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:famili/components/api_observer.dart';
import 'package:famili/components/app_bar.dart';
import 'package:famili/components/image_item.dart';
import 'package:famili/components/product/product_grid.dart';
import 'package:famili/constants/colors.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/screens/homescreen/home_screen_bloc.dart';
import 'package:famili/screens/productdetailscreen/product_detail_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final List<String> imgList = [
    'https://s1.bukalapak.com/rev-banner/flash_banner/64884/homepage_banner/s-834-352/Banner_A-B_Test_-_3.jpg.webp',
    'https://s1.bukalapak.com/rev-banner/flash_banner/62984/homepage_banner/s-834-352/Banner_A-B_Test_%282%29.jpg.webp',
    'https://s1.bukalapak.com/rev-banner/flash_banner/63094/homepage_banner/s-834-352/MagerBanner_A-B_Test.jpg.webp'
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double targetElevation = 0.8;
  double _elevation = 0;
  ScrollController _controller;
  int _currentSlider = 0;

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? targetElevation : 0;
    if (_elevation != newElevation) {
      setState(() {
        _elevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    homeBloc.getProducts();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  Future<Null> _refresh() async {
    homeBloc.getProducts();
  }

  _buildImageSlider() {
    return widget.imgList
        .map((item) =>
        Container(
          height: 200,
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: ImageItem(url: item)),
        ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorBase.whiteGray));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarMV.titleWidget(
          titleWidget: _titleWidget(),
          elevation: _elevation,
          actions: <Widget>[
            Badge(
                badgeContent: Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                position: BadgePosition.topRight(top: 5, right: 7),
                child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black54,
                    ),
                    onPressed: null)),
            Badge(
              badgeContent: Text(
                '3',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              position: BadgePosition.topRight(top: 5, right: 7),
              child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black54,
                  ),
                  onPressed: null),
            )
          ],
        ),
        body: RefreshIndicator(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) =>
                _onScrollNotification(notification),
            child: ListView(
              controller: _controller,
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                _buildBanner(),
                Divider(
                  color: ColorBase.whiteGray,
                  thickness: 8.0,
                ),
                _buildAllProduct()
              ],
            ),
          ),
          onRefresh: _refresh,
        ));
  }

  Widget _buildAllProduct() {
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 6.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Semua Produk",
                    style: TextStyle(
                        color: ColorBase.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ApiObserver(
                stream: homeBloc.productsSubject.stream,
                onSuccess: (context, ProductPaginate response) =>
                    ProductGrid(
                      response,
                    ),
                onErrorReload: () {
                    homeBloc.getProducts(page: homeBloc.lastPage);
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildBanner() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 3.0,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSlider = index;
                });
              }),
          items: _buildImageSlider(),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.imgList.map((url) {
                  int index = widget.imgList.indexOf(url);
                  return Container(
                    width: _currentSlider == index ? 10.0 : 8.0,
                    height: _currentSlider == index ? 10.0 : 8.0,
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentSlider == index
                          ? ColorBase.primary
                          : Colors.grey[400],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleWidget() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
            height: 24,
            child: Icon(
              Icons.search,
              color: Colors.black54,
            )),
        SizedBox(width: 10),
        InkWell(
          onTap: null,
          child: Text(Constant.searchPlaceholder,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        )
      ]),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorBase.whiteGray,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: Colors.black12,
            ),
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _controller.position.extentAfter == 0) {
      var nextPage = homeBloc.nextPage;
      if (nextPage != null && !homeBloc.isLoading) {
        homeBloc.getProducts(page: nextPage);
      }
    }
  }
}
