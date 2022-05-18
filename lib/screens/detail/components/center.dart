import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl_browser.dart';

class CenterPage extends StatefulWidget {
  //var indexGame;
  var nameGame;
  var steamAppid;
  var gogAppid;
  String imageGame;
  String steamPrice;
  CenterPage(
      {Key? key,
      //required this.indexGame,
      required this.nameGame,
      required this.steamAppid,
      required this.gogAppid,
      required this.imageGame,
      required this.steamPrice})
      : super(key: key);

  @override
  State<CenterPage> createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  var gogPrice;

  var jsonDataGOG;

  var screenshots;

  var descGame;

  var genresGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: consultarTamanhoSteam(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Algum error ocorreu'),
                );
              } else {
                return Row(children: [
                  Expanded(
                    child: GameDetailCard(
                        steamPrice: widget.steamPrice,
                        imageGame: widget.imageGame,
                        steamAppid: widget.steamAppid,
                        gogPrice: gogPrice,
                        gogAppid: widget.gogAppid,
                        jsonDataGOG: jsonDataGOG,
                        screenshots: screenshots,
                        descGame: descGame,
                        genresGame: genresGame),
                  ),
                ]);
              }
            }
          }),
    );
  }

  Future<List<Steam>> consultarTamanhoSteam() async {
    http.Response responseSteam =
        await http.get(Uri.parse("$apiSteam${widget.steamAppid}&cc=BR"));
    final jsonDataDetail = jsonDecode(responseSteam.body);
    http.Response responseGOGPrice = await http
        .get(Uri.parse("$apiGOGPrice${widget.gogAppid}/prices?countryCode=BR"));
    final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
    http.Response responseGOGDetail =
        await http.get(Uri.parse("$apiGOG${widget.gogAppid}"));
    final jsonDataApiGOG = jsonDecode(responseGOGDetail.body);
    jsonDataGOG = jsonDataApiGOG;
    screenshots = jsonDataDetail["${widget.steamAppid}"]["data"]["screenshots"];
    gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
    if (gogPrice != null && gogPrice.length > 0) {
      gogPrice = gogPrice.substring(0, gogPrice.length - 4);
    }
    final currencyFormatter = NumberFormat('#,##0.00', 'pt_BR');
    var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
    gogPrice = "${format.currencySymbol}" +
        currencyFormatter.format(int.parse(gogPrice) / 100);
    var detailGame =
        jsonDataDetail["${widget.steamAppid}"]["data"]["short_description"];
    descGame = detailGame;
    var genreGame = jsonDataDetail["${widget.steamAppid}"]["data"]["genres"];
    genresGame = genreGame;
    List<Steam> steams = [];
    List<String> steamDetail;
    return steams;
  }
}

class GameDetailCard extends StatelessWidget {
  GameDetailCard({
    Key? key,
    required this.steamPrice,
    required this.imageGame,
    required this.steamAppid,
    required this.gogAppid,
    required this.gogPrice,
    required this.jsonDataGOG,
    required this.screenshots,
    required this.descGame,
    required this.genresGame,
  }) : super(key: key);

  var steamPrice;
  var imageGame;
  var steamAppid;
  var gogPrice;
  var gogAppid;
  var jsonDataGOG;
  var screenshots = [];
  var descGame;
  var genresGame = [];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: defaultPadding),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      CustomListItem(
                        user: 'Genero',
                        price: steamPrice,
                        thumbnail: Image.network(imageGame),
                        title: 'Steam',
                        icon: steamIcon,
                        appid: steamAppid,
                        steam: true,
                        jsonDataGOG: '',
                        descGame: descGame,
                        genresGame: genresGame,
                      ),
                      CustomListItem(
                        user: 'Genero',
                        price: gogPrice,
                        thumbnail: Image.network(imageGame),
                        title: 'GOG',
                        icon: gogIcon,
                        appid: gogAppid,
                        steam: false,
                        jsonDataGOG: jsonDataGOG,
                        descGame: '',
                        genresGame: [],
                      ),
                      GridView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: defaultPadding * 2,
                          mainAxisSpacing: defaultPadding,
                        ),
                        itemBuilder: (context, index) => Image.network(
                          screenshots[index]["path_thumbnail"],
                          height: 150,
                          width: 150,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      tablet: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: defaultPadding),
          Expanded(
            child: Row(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      CustomListItem(
                        user: 'Genero',
                        price: steamPrice,
                        thumbnail: Image.network(imageGame),
                        title: 'Steam',
                        icon: steamIcon,
                        appid: steamAppid,
                        steam: true,
                        jsonDataGOG: '',
                        descGame: descGame,
                        genresGame: genresGame,
                      ),
                      CustomListItem(
                          user: 'Genero',
                          price: gogPrice,
                          thumbnail: Image.network(imageGame),
                          title: 'GOG',
                          icon: gogIcon,
                          appid: gogAppid,
                          steam: false,
                          jsonDataGOG: jsonDataGOG,
                          descGame: 'Teste',
                          genresGame: []),
                      GridView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: defaultPadding * 2,
                          mainAxisSpacing: defaultPadding,
                        ),
                        itemBuilder: (context, index) => Image.network(
                          screenshots[index]["path_thumbnail"],
                          height: 150,
                          width: 150,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: defaultPadding),
          Expanded(
            child: Row(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      CustomListItem(
                        user: 'Genero',
                        price: steamPrice,
                        thumbnail: Image.network(imageGame),
                        title: 'Steam',
                        icon: steamIcon,
                        appid: steamAppid,
                        steam: true,
                        jsonDataGOG: '',
                        descGame: descGame,
                        genresGame: genresGame,
                      ),
                      CustomListItem(
                        user: 'Genero',
                        price: gogPrice,
                        thumbnail: Image.network(imageGame),
                        title: 'GOG',
                        icon: gogIcon,
                        appid: gogAppid,
                        steam: false,
                        jsonDataGOG: jsonDataGOG,
                        descGame: '',
                        genresGame: [],
                      ),
                      GridView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                        ),
                        itemBuilder: (context, index) => Image.network(
                          screenshots[index]["path_thumbnail"],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  _VideoDescription({
    Key? key,
    required this.title,
    required this.user,
    required this.price,
    required this.icon,
    required this.appid,
    required this.steamBool,
    required this.jsonDataGOG,
    required this.genresGame,
  }) : super(key: key);

  final String title;
  final String user;
  final String price;
  final String icon;
  final String appid;
  final bool steamBool;
  var jsonDataGOG;
  var genresGame;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Descrição: $user',
            style: const TextStyle(fontSize: 10.0),
          ),
          currentWidth >= 810
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 25.0))
              : const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
          OutlinedButton.icon(
            onPressed: () {
              steamBool == true ? _steamURL(appid) : _gogURL(appid);
            },
            icon: currentWidth >= 810
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4, bottom: 4),
                    child: Image.asset(
                      icon,
                      width: 35,
                      height: 35,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4, bottom: 4),
                    child: Image.asset(
                      icon,
                      width: 30,
                      height: 30,
                    ),
                  ),
            label: Text(
              "Preço $price",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  _steamURL(String appid) async {
    String url = '$steam$appid';
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }

  _gogURL(String appid) async {
    String url = jsonDataGOG["_links"]["store"]["href"];
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem(
      {Key? key,
      required this.thumbnail,
      required this.title,
      required this.user,
      required this.price,
      required this.icon,
      required this.appid,
      required this.steam,
      required this.jsonDataGOG,
      required this.descGame,
      required this.genresGame})
      : super(key: key);

  final Widget thumbnail;
  final String title;
  final String user;
  final String price;
  final String icon;
  final String appid;
  final bool steam;
  final String descGame;
  var jsonDataGOG;
  var genresGame = [];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: thumbnail,
            ),
            Expanded(
              child: _VideoDescription(
                title: title,
                user: user,
                price: price,
                icon: icon,
                appid: appid,
                steamBool: steam,
                jsonDataGOG: jsonDataGOG,
                genresGame: genresGame,
              ),
            ),
            Expanded(
                flex: 2,
                child: steam == true
                    ? DetailCard(descGame: descGame, genresGame: genresGame)
                    : Container())
          ],
        ),
      ),
      tablet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: thumbnail,
            ),
            Expanded(
              flex: 3,
              child: _VideoDescription(
                  title: title,
                  user: user,
                  price: price,
                  icon: icon,
                  appid: appid,
                  steamBool: steam,
                  jsonDataGOG: jsonDataGOG,
                  genresGame: genresGame),
            ),
          ],
        ),
      ),
      mobile: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: thumbnail,
            ),
            Expanded(
              flex: 3,
              child: _VideoDescription(
                  title: title,
                  user: user,
                  price: price,
                  icon: icon,
                  appid: appid,
                  steamBool: steam,
                  jsonDataGOG: jsonDataGOG,
                  genresGame: genresGame),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  DetailCard({
    Key? key,
    required this.descGame,
    required this.genresGame,
  }) : super(key: key);

  _genresGame() {
    genresText = genresGame[0]["description"];
    var length = genresGame.length;
    if (length > 1) {
      for (int i = 1; i < length; i++) {
        var text = genresGame[i]["description"];
        genresText = genresText + ', ' + '$text';
      }
    }
    return genresText;
  }

  final String descGame;
  var genresGame;
  var genresText;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Descrição: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: descGame),
              ])) //Text('Descrição :$descGame'),
              ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Genero(s): ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: _genresGame())
              ])) //Text('Descrição :$descGame'),
              ),
        ],
      ),
    );
  }
}
