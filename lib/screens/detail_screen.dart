import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/detail/detail_center.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';

class DetailScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var indexGame;
  final String nameGame;
  final String steamAppid;
  final String gogAppid;
  final String imageGame;
  final String steamPrice;
  DetailScreen({
    Key? key,
    required this.indexGame,
    required this.nameGame,
    required this.steamAppid,
    required this.gogAppid,
    required this.steamPrice,
    required this.imageGame,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        pageState: 'Detail_Page',
      ),
      body: Responsive(
        mobile: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.only(left: 15, top: 23),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: DetailCenter(
              nameGame: nameGame,
              indexGame: indexGame,
              steamAppid: steamAppid,
              imageGame: imageGame,
              gogAppid: gogAppid,
              steamPrice: steamPrice,
            ),
          )
        ]),
        tablet: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 1,
            child: SideMenu(
              pageState: 'Detail_Page',
            ),
          ),
          Expanded(
            flex: 3,
            child: DetailCenter(
              nameGame: nameGame,
              indexGame: indexGame,
              steamAppid: steamAppid,
              gogAppid: gogAppid,
              steamPrice: steamPrice,
              imageGame: imageGame,
            ),
          ),
        ]),
        desktop: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SideMenu(
              pageState: 'Detail_Page',
            ),
          ),
          Expanded(
            flex: 5,
            child: DetailCenter(
              nameGame: nameGame,
              indexGame: indexGame,
              steamAppid: steamAppid,
              imageGame: imageGame,
              gogAppid: gogAppid,
              steamPrice: steamPrice,
            ),
          ),
        ]),
      ),
    );
  }
}
