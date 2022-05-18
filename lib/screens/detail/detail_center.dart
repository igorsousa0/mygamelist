import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/center/components/header.dart';
import 'package:mygamelist/screens/detail/components/center.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';

class DetailCenter extends StatefulWidget {
  var indexGame;
  var nameGame;
  var steamAppid;
  var gogAppid;
  final String imageGame;
  final String steamPrice;
  DetailCenter({
    Key? key,
    required this.indexGame,
    required this.nameGame,
    required this.steamAppid,
    required this.gogAppid,
    required this.imageGame,
    required this.steamPrice,
  }) : super(key: key);

  @override
  State<DetailCenter> createState() => _DetailCenterState();
}

class _DetailCenterState extends State<DetailCenter> {
  String steamFilter = '';

  changeState(String text) {
    setState(() {
      steamFilter = text;
    });
  }

  changeStateLogin(bool loginState, String loginText) {
    setState(() {
      loginTextGlobal = loginText;
      loginGlobal = loginState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(right: defaultPadding),
              child: Header(
                pageText: widget.nameGame,
                pageState: 'Detail_Page',
                changeState: changeState,
              ),
            ),
            //Login(),
            SizedBox(height: defaultPadding),
            Expanded(
              child: CenterPage(
                  nameGame: widget.nameGame,
                  steamAppid: widget.steamAppid,
                  gogAppid: widget.gogAppid,
                  imageGame: widget.imageGame,
                  steamPrice: widget.steamPrice),
            ),
          ],
        ),
      ),
    );
  }
}
