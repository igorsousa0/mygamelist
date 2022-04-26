import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/detail/components/detail_header.dart';
import 'package:mygamelist/screens/detail/detail_center.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';

class DetailScreen extends StatelessWidget {
  var indexGame;
  final String nameGame;
  final String steamAppid;
  final String gogAppid;
  DetailScreen({
    Key? key,
    required this.indexGame,
    required this.nameGame,
    required this.steamAppid,
    required this.gogAppid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: Container(),
        tablet: Container(),
        desktop: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: DetailCenter(
              nameGame: nameGame,
              indexGame: indexGame,
              steamAppid: steamAppid,
              gogAppid: gogAppid,
            ),
          ),
        ]),
      ),
    );
  }
}
