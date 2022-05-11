import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/screens/detail_screen.dart';
import 'package:mygamelist/user.dart';
import 'components/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CenterScreen extends StatefulWidget {
  const CenterScreen({Key? key}) : super(key: key);

  @override
  State<CenterScreen> createState() => _CenterScreenState();
}

class _CenterScreenState extends State<CenterScreen> {
  String steamFilter = '';
  changeState(String text) {
    setState(() {
      steamFilter = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(right: defaultPadding),
              child:
                  Header(changeState: changeState, pageText: 'Pagina Inicial'),
            ),
            //Login(),
            SizedBox(height: defaultPadding),
            Expanded(
              child: Contents(steamFilter: steamFilter),
            ),
            ControlPage(),
          ],
        ),
      ),
    );
  }
}

class Contents extends StatefulWidget {
  final String steamFilter;
  Contents({
    required this.steamFilter,
    Key? key,
  }) : super(key: key);

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  static var gogUrls = [];
  static var gogAppids = [];
  @override
  void initState() {
    super.initState();
    //test = ProfileCard(this.cal)
  }

  Future<List<Steam>> consultarDados() async {
    var steamFilter = widget.steamFilter;
    http.Response responseApiSteam =
        await http.get(Uri.parse("$api/steamapi/?name=$steamFilter"));
    var jsonDataApiSteam = jsonDecode(responseApiSteam.body);
    http.Response responseApiGOG = await http.get(Uri.parse("$api/gog/"));
    var jsonDataApiGOG = jsonDecode(responseApiGOG.body);
    List<Steam> steams = [];
    List<String> steamDetail;
    for (var i in jsonDataApiSteam) {
      var SteamAppid = i["appid"];
      http.Response responseSteam =
          await http.get(Uri.parse("$apiSteam$SteamAppid&cc=BR"));
      final jsonDataDetail = jsonDecode(responseSteam.body);
      var scoreGame = jsonDataDetail["$SteamAppid"]["data"]["metacritic"];

      if (scoreGame == null) {
        scoreGame = null;
      } else {
        scoreGame =
            jsonDataDetail["$SteamAppid"]["data"]["metacritic"]["score"];
      }
      String steamPrice = jsonDataDetail["$SteamAppid"]["data"]
          ["price_overview"]["final_formatted"];
      final currencyFormatter = NumberFormat('#,##0.00', 'pt_BR');
      var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
      steamPrice = steamPrice.substring(3, steamPrice.length);
      steamPrice = "${format.currencySymbol}" + steamPrice;

      Steam steam = Steam(
        appid: i["appid"],
        name: i["name"],
        image: jsonDataDetail["$SteamAppid"]["data"]["header_image"],
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
                return ItemCard(snapshot);
              }
            }
          }),
    );
  }

  Widget ItemCard(snapshot) {
    return Container(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        ListTile(
                          title: Text(
                            snapshot.data[index].name,
                            style: TextStyle(
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
                                        (snapshot.data[index].score).toString(),
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
                                  child: Center(
                                    child: Text('?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  )),
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
    );
  }
}

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Spacer(),
            Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white54,
              size: 24.0,
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white54,
              size: 24.0,
            ),
          ],
        )
      ],
    );
  }
}
