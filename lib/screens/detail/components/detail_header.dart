import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/center/components/header.dart';
import 'package:mygamelist/user.dart';
import 'dart:convert';

class DetailHeader extends StatelessWidget {
  voidFunction() {
    return '';
  }

  var nameGame;
  DetailHeader({
    Key? key,
    required this.nameGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(nameGame,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.4)),
          ),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
      tablet: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(nameGame, style: Theme.of(context).textTheme.headline6),
          ),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
      desktop: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(nameGame, style: Theme.of(context).textTheme.headline6),
          ),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
    );
  }
}
