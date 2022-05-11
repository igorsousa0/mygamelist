import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/detail/components/center.dart';
import 'package:mygamelist/screens/detail/components/detail_header.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';

class DetailCenter extends StatelessWidget {
  var indexGame;
  var nameGame;
  var steamAppid;
  var gogAppid;
  final String imageGame;
  final String steamPrice;
  DetailCenter(
      {Key? key,
      required this.indexGame,
      required this.nameGame,
      required this.steamAppid,
      required this.gogAppid,
      required this.imageGame,
      required this.steamPrice})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(right: defaultPadding),
              child: DetailHeader(nameGame: nameGame),
            ),
            //Login(),
            SizedBox(height: defaultPadding),
            Expanded(
              child: CenterPage(
                  nameGame: nameGame,
                  steamAppid: steamAppid,
                  gogAppid: gogAppid,
                  imageGame: imageGame,
                  steamPrice: steamPrice),
            ),
          ],
        ),
      ),
    );
  }
}
