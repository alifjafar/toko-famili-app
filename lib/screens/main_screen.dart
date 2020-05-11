import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/constants/dimens.dart';
import 'package:famili/constants/navigation.dart';
import 'package:famili/core/data/user_prefs.dart';
import 'package:famili/core/navigation_service.dart';
import 'package:flutter/material.dart';
import '../injection.dart';
import 'homescreen/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;
  List<dynamic> widgetItems;
  var userPref = locator<UserPref>();

  @override
  void initState() {
    _initializeBottomNavBar();
    super.initState();
//    homeBloc.getProducts();
  }

  void onTabTapped(int index) async {
    if (widgetItems[index]['auth']) {
      var isLogged = await userPref.isLogged();
      if(!isLogged) {
        locator<NavigationService>()
            .navigateTo(NavigationConstant.Login);
        return;
      }
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: onTabTapped,
      ),
      body: _buildContent(_currentIndex),
    );
  }

  Widget _buildContent(int index) {
    return widgetItems[index]['widget'];
  }

  _initializeBottomNavBar() {
    badger = BottomNavigationBadge(
        backgroundColor: Colors.red,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 8);

    items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.home, size: Dimens.navBarIconSize),
          title: Column(children: <Widget>[
            SizedBox(height: Dimens.navBarBoxSize),
            Text(Constant.home),
          ])),
      BottomNavigationBarItem(
          icon: Icon(Icons.category, size: Dimens.navBarIconSize),
          title: Column(children: <Widget>[
            SizedBox(height: Dimens.navBarBoxSize),
            Text(Constant.category),
          ])),
      BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, size: Dimens.navBarIconSize),
          title: Column(children: <Widget>[
            SizedBox(height: Dimens.navBarBoxSize),
            Text(Constant.transaction),
          ])),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: Dimens.navBarIconSize),
          title: Column(children: <Widget>[
            SizedBox(height: Dimens.navBarBoxSize),
            Text(Constant.account),
          ]))
    ];

    widgetItems = [
      {'auth': false, 'widget': HomeScreen()},
      {'auth': false, 'widget': HomeScreen()},
      {'auth': false, 'widget': HomeScreen()},
      {'auth': false, 'widget': HomeScreen()}
    ];
  }
}
