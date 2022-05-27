import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/detail_screen.dart';
import 'components/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CenterScreen extends StatefulWidget {
  const CenterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CenterScreen> createState() => _CenterScreenState();
}

class _CenterScreenState extends State<CenterScreen> {
  String steamFilter = '';

  changeStateSteam(String text) {
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
      drawer: const Drawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: defaultPadding),
              child: Header(
                  changeState: changeStateSteam,
                  pageState: 'Home_Page',
                  pageText: 'Pagina Inicial'),
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: Contents(
                steamFilter: steamFilter,
                changeStateSteam: changeStateSteam,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contents extends StatefulWidget {
  final String steamFilter;
  final Function changeStateSteam;
  const Contents({
    required this.steamFilter,
    required this.changeStateSteam,
    Key? key,
  }) : super(key: key);

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  static var gogAppids = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<Steam>> consultarDados() async {
    var steamFilter = widget.steamFilter;
    http.Response responseApiSteam =
        await http.get(Uri.parse("$api/steamapi/?name=$steamFilter"));
    var jsonDataApiSteam = jsonDecode(responseApiSteam.body);
    http.Response responseApiGOG = await http.get(Uri.parse("$api/gog/"));
    var jsonDataApiGOG = jsonDecode(responseApiGOG.body);
    List<Steam> steams = [];
    for (var i in jsonDataApiSteam) {
      var steamAppid = i["appid"];
      http.Response responseSteam =
          await http.get(Uri.parse("$apiSteam$steamAppid&cc=BR"));
      final jsonDataDetail = jsonDecode(responseSteam.body);
      var scoreGame = jsonDataDetail["$steamAppid"]["data"]["metacritic"];

      if (scoreGame == null) {
        scoreGame = null;
      } else {
        scoreGame =
            jsonDataDetail["$steamAppid"]["data"]["metacritic"]["score"];
      }
      String steamPrice = jsonDataDetail["$steamAppid"]["data"]
          ["price_overview"]["final_formatted"];
      var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
      steamPrice = steamPrice.substring(3, steamPrice.length);
      steamPrice = "${format.currencySymbol}" + steamPrice;

      Steam steam = Steam(
        appid: i["appid"],
        name: i["name"],
        image: jsonDataDetail["$steamAppid"]["data"]["header_image"],
        score: scoreGame,
        price: steamPrice,
      );
      steams.add(steam);
    }
    for (var i in jsonDataApiGOG) {
      var gogAppid = i["appid"];
      gogAppids.add(gogAppid);
    }
    return steams;
  }

  Color colorScore(score) {
    if (score >= 75) {
      return Colors.lightGreen.shade600;
    } else if (score >= 50 && score <= 74) {
      return Colors.yellow.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  Color colorText(score) {
    if (score >= 50 && score <= 74) {
      return Colors.grey.shade600;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: consultarDados(),
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
                return itemCard(snapshot);
              }
            }
          }),
    );
  }

  Widget itemCard(snapshot) {
    double width = MediaQuery.of(context).size.width;
    return Responsive(
      tablet: Container(
        padding: const EdgeInsets.only(
            left: defaultPadding, right: defaultPadding, top: defaultPadding),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: PageView(
          children: [
            Column(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: GridView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: defaultPadding * 2,
                      mainAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) => Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        indexGame: snapshot.data[index],
                                        nameGame: snapshot.data[index].name,
                                        steamAppid: snapshot.data[index].appid,
                                        steamPrice: snapshot.data[index].price,
                                        imageGame: snapshot.data[index].image,
                                        gogAppid: gogAppids[index],
                                      ),
                                    ),
                                  ),
                              child: Image.network(snapshot.data[index].image)),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              leading: snapshot.data[index].score != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: colorScore(
                                              snapshot.data[index].score)),
                                      height: 27,
                                      width: 27,
                                      child: Center(
                                        child: Text(
                                            (snapshot.data[index].score)
                                                .toString(),
                                            style: TextStyle(
                                                color: colorText(
                                                    snapshot.data[index].score),
                                                fontWeight: FontWeight.bold)),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade400),
                                      height: 27,
                                      width: 27,
                                      child: const Center(
                                        child: Text('?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      mobile: Container(
        padding: const EdgeInsets.only(
            left: defaultPadding, right: defaultPadding, top: defaultPadding),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: PageView(
          children: [
            Column(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: GridView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width < 515 ? 1 : 2,
                      crossAxisSpacing: defaultPadding * 2,
                      mainAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) => Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        indexGame: snapshot.data[index],
                                        nameGame: snapshot.data[index].name,
                                        steamAppid: snapshot.data[index].appid,
                                        steamPrice: snapshot.data[index].price,
                                        imageGame: snapshot.data[index].image,
                                        gogAppid: gogAppids[index],
                                      ),
                                    ),
                                  ),
                              child: Image.network(snapshot.data[index].image)),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              leading: snapshot.data[index].score != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: colorScore(
                                              snapshot.data[index].score)),
                                      height: 27,
                                      width: 27,
                                      child: Center(
                                        child: Text(
                                            (snapshot.data[index].score)
                                                .toString(),
                                            style: TextStyle(
                                                color: colorText(
                                                    snapshot.data[index].score),
                                                fontWeight: FontWeight.bold)),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade400),
                                      height: 27,
                                      width: 27,
                                      child: const Center(
                                        child: Text('?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      desktop: Container(
        padding: const EdgeInsets.only(
            left: defaultPadding, right: defaultPadding, top: defaultPadding),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: PageView(
          children: [
            Column(
              children: [
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: GridView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: defaultPadding * 2,
                      mainAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) => Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        indexGame: snapshot.data[index],
                                        nameGame: snapshot.data[index].name,
                                        steamAppid: snapshot.data[index].appid,
                                        steamPrice: snapshot.data[index].price,
                                        imageGame: snapshot.data[index].image,
                                        gogAppid: gogAppids[index],
                                      ),
                                    ),
                                  ),
                              child: Image.network(snapshot.data[index].image)),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              leading: snapshot.data[index].score != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: colorScore(
                                              snapshot.data[index].score)),
                                      height: 27,
                                      width: 27,
                                      child: Center(
                                        child: Text(
                                            (snapshot.data[index].score)
                                                .toString(),
                                            style: TextStyle(
                                                color: colorText(
                                                    snapshot.data[index].score),
                                                fontWeight: FontWeight.bold)),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors
                                              .blueGrey.shade400 //Colors.blue,
                                          ),
                                      height: 27,
                                      width: 27,
                                      child: const Center(
                                        child: Text('?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
