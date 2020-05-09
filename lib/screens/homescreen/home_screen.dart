import 'package:famili/components/api_observer.dart';
import 'package:famili/components/app_bar.dart';
import 'package:famili/components/product/product_grid.dart';
import 'package:famili/constants/colors.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/screens/homescreen/home_screen_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double targetElevation = 0.8;
  double _elevation = 0;
  ScrollController _controller;

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorBase.whiteGray));
    return Scaffold(
        appBar: AppBarMV.titleWidget(
          titleWidget: _titleWidget(context),
          elevation: _elevation,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black54,
                ),
                onPressed: null)
          ],
        ),
        body: RefreshIndicator(
          child: Container(
            width: double.infinity,
            child: ApiObserver(
              stream: homeBloc.productsSubject.stream,
              onSuccess: (context, ProductCollection response) => ProductGrid(
                response,
              ),
            ),
          ),
          onRefresh: _refresh,
        ));
  }

  Widget _titleWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)),
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
}
