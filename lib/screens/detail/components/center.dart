import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/detail/components/detail_header.dart';
import 'package:mygamelist/screens/home/components/side_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl_browser.dart';

class CenterPage extends StatelessWidget {
  //var indexGame;
  var nameGame;
  var imageGame;
  var steamPrice;
  var steamAppid;
  var gogAppid;
  var gogPrice;
  var jsonDataGOG;
  var screenshots = [];
  CenterPage({
    Key? key,
    //required this.indexGame,
    required this.nameGame,
    required this.steamAppid,
    required this.gogAppid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: consultarTamanhoSteam(steamAppid, gogAppid),
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
                return Column(children: [
                  Container(
                    child: Expanded(
                      child: GameDetailCard(
                          steamPrice: steamPrice,
                          imageGame: imageGame,
                          steamAppid: steamAppid,
                          gogPrice: gogPrice,
                          gogAppid: gogAppid,
                          jsonDataGOG: jsonDataGOG,
                          screenshots: screenshots),
                    ),
                  ),
                ]);
              }
            }
          }),
    );
  }

  Future<List<Steam>> consultarTamanhoSteam(
      String steamAppid, String gogAppid) async {
    http.Response responseSteam =
        await http.get(Uri.parse("$apiSteam$steamAppid&cc=BR"));
    final jsonDataDetail = jsonDecode(responseSteam.body);
    http.Response responseGOGPrice = await http
        .get(Uri.parse("$apiGOGPrice$gogAppid/prices?countryCode=BR"));
    final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
    http.Response responseGOGDetail =
        await http.get(Uri.parse("$apiGOG$gogAppid"));
    final jsonDataApiGOG = jsonDecode(responseGOGDetail.body);
    jsonDataGOG = jsonDataApiGOG;
    imageGame = jsonDataDetail["$steamAppid"]["data"]["header_image"];
    steamPrice = jsonDataDetail["$steamAppid"]["data"]["price_overview"]
        ["final_formatted"];
    screenshots = jsonDataDetail["$steamAppid"]["data"]["screenshots"];
    //print(screenshots[0]["id"]);
    gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
    if (gogPrice != null && gogPrice.length > 0) {
      gogPrice = gogPrice.substring(0, gogPrice.length - 4);
    }
    final currencyFormatter = NumberFormat('#,##0.00', 'pt_BR');
    var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
    steamPrice = steamPrice.substring(3, steamPrice.length);
    steamPrice = "${format.currencySymbol}" + steamPrice;
    gogPrice = "${format.currencySymbol}" +
        currencyFormatter.format(int.parse(gogPrice) / 100);
    // Estruturação no nome para uso da API Metacritic
    /*String nameTest = nameGame;
    nameTest = nameTest.replaceAll('  ', ' ');
    nameTest = nameTest.replaceAll(' - ', '-');
    nameTest = nameTest.replaceAll(':', '');
    nameTest = nameTest.replaceAll(' ', '-');
    //print(nameTest.replaceAll(' ', '-'));
    print(nameTest);*/
    /*steamPrices.add(jsonDataDetail["$SteamAppid"]["data"]["price_overview"]["final_formatted"]);
      steamAppids.add(SteamAppid);*/
    /*Steam steam = Steam(
        SteamAppid,
        steamImage,
        steamPrice,
      );*/
    /*setState(() {
        steamImages.add(steamImage);
      });*/
    List<Steam> steams = [];
    List<String> steamDetail;
    /*for (var i in jsonDataApiGOG) {
      var gogAppid = i["appid"];
      http.Response responseGOGDetail = await http.get(Uri.parse("$apiGOG$gogAppid"));
      final jsonDataDetailGOG = jsonDecode(responseGOGDetail.body);
      //http.Response responseGOGPrice = await http.get(Uri.parse("$apiGOGPrice$gogAppid/prices?countryCode=BR"));
      //final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
      //print(jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"]);
      //var gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
      //gogPrices.add(gogPrice);
      //print(jsonDataPriceGOG["_embedded"]["prices"]["finalPrice"]);
    }*/
    return steams;
    /*setState(() {
      lenght = jsonData.length;
      jsonDataSteam = jsonData;
    });
    consultaSteam(1);*/
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
  }) : super(key: key);

  var steamPrice;
  var imageGame;
  var steamAppid;
  var gogPrice;
  var gogAppid;
  var jsonDataGOG;
  var screenshots = [];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Column(
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
  }) : super(key: key);

  final String title;
  final String user;
  final String price;
  final String icon;
  final String appid;
  final bool steamBool;
  var jsonDataGOG;

  @override
  Widget build(BuildContext context) {
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
          const Padding(padding: EdgeInsets.symmetric(vertical: 25.0)),
          OutlinedButton.icon(
            onPressed: () {
              steamBool == true ? _steamURL(appid) : _gogURL(appid);
            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 4, right: 4, bottom: 4),
              child: Image.asset(
                icon,
                width: 35,
                height: 35,
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
  CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.user,
    required this.price,
    required this.icon,
    required this.appid,
    required this.steam,
    required this.jsonDataGOG,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String user;
  final String price;
  final String icon;
  final String appid;
  final bool steam;
  var jsonDataGOG;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
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
              ),
            ),
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
              ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
